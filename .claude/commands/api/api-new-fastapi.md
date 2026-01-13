---
description: Create a new FastAPI endpoint with controller, service, and DTOs
model: claude-sonnet-4-5
---

Create a new FastAPI endpoint following the layered architecture pattern.

## Requirements

API Endpoint: $ARGUMENTS

## Implementation Guidelines

### 1. **Project Structure**
Follow the standard FastAPI layered architecture:
- `app/controllers/` - API routers with FastAPI endpoints
- `app/services/` - Business logic layer
- `app/repositories/` - Database access layer (if needed)
- `app/models/entities.py` - SQLAlchemy ORM models
- `app/models/request_dtos.py` - Pydantic request DTOs
- `app/models/response_dtos.py` - Pydantic response DTOs

### 2. **Controller Pattern**
Use FastAPI APIRouter with dependency injection:

```python
from typing import Annotated
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.config.database import get_db
from app.models.request_dtos import ItemRequestDTO, QueryParams
from app.models.response_dtos import ItemResponseDTO, PaginatedResponseDTO
from app.services.item_service import ItemService
from app.utils.security_utils import is_user_or_up, is_admin_or_up
from app.models.entities import User

router = APIRouter(tags=["Items"])

db_dep = Annotated[Session, Depends(get_db)]
user_dep = Annotated[User, Depends(is_user_or_up)]
admin_dep = Annotated[User, Depends(is_admin_or_up)]


@router.get("/items", response_model=PaginatedResponseDTO[ItemResponseDTO])
def get_items(db: db_dep, current_user: user_dep, query_params: QueryParams = Depends()):
    service = ItemService(db)
    result = service.get_items(query_params)
    return result


@router.post("/items", response_model=ItemResponseDTO)
def create_item(item_dto: ItemRequestDTO, db: db_dep, current_user: user_dep):
    service = ItemService(db)
    item = service.create_item(item_dto)
    return item


@router.get("/items/{item_id}", response_model=ItemResponseDTO)
def get_item(item_id: int, db: db_dep, current_user: user_dep):
    service = ItemService(db)
    item = service.get_item(item_id)
    return item


@router.put("/items/{item_id}", response_model=ItemResponseDTO)
def update_item(item_id: int, item_dto: ItemRequestDTO, db: db_dep, current_user: user_dep):
    service = ItemService(db)
    item = service.update_item(item_id, item_dto.dict(exclude_none=True))
    return item


@router.delete("/items/{item_id}", status_code=204)
def delete_item(item_id: int, db: db_dep, current_user: admin_dep):
    service = ItemService(db)
    service.delete_item(item_id)
```

### 3. **Request DTOs**
Define Pydantic models for incoming data in `request_dtos.py`:

```python
from typing import Optional
from pydantic import BaseModel, Field, ConfigDict


class BaseModelIgnore(BaseModel):
    model_config = ConfigDict(extra='ignore')


class ItemRequestDTO(BaseModelIgnore):
    name: str = Field(min_length=1, max_length=256)
    description: Optional[str] = None
    quantity: int = Field(gt=0)
    is_active: bool = True
```

### 4. **Response DTOs**
Define Pydantic models for outgoing data in `response_dtos.py`:

```python
from datetime import datetime
from typing import Optional
from pydantic import BaseModel


class ItemResponseDTO(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    quantity: int
    is_active: bool
    created_on: Optional[datetime] = None
    updated_on: Optional[datetime] = None
```

### 5. **Repository Layer**
For complex queries or to separate database access logic, create a repository in `app/repositories/`:

**Simple Repository Pattern:**
```python
from sqlalchemy import delete, func
from sqlalchemy.orm import Session

from app.models.entities import Item


class ItemRepository:
    def __init__(self, db: Session):
        self.db = db

    def create_item(self, item: Item) -> Item:
        self.db.add(item)
        self.db.commit()
        self.db.refresh(item)
        return item

    def get_item_by_id(self, item_id: int) -> Item:
        return self.db.query(Item).filter(Item.id == item_id).first()

    def update_item(self, item: Item) -> Item:
        self.db.commit()
        self.db.refresh(item)
        return item

    def delete_item_by_id(self, item_id: int) -> None:
        self.db.execute(delete(Item).where(Item.id == item_id))
        self.db.commit()

    def delete_items_by_ids(self, item_ids: list[int]) -> None:
        self.db.execute(delete(Item).where(Item.id.in_(item_ids)))
        self.db.commit()

    def get_items_count(self) -> int:
        return self.db.query(func.count(Item.id)).scalar()
```

### 6. **Service Layer**
Implement business logic in service classes.

```python
from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.entities import Item
from app.models.request_dtos import ItemRequestDTO, QueryParams
from app.models.response_dtos import ItemResponseDTO, PaginatedResponseDTO
from app.repositories.item_repository import ItemRepository


class ItemService:
    def __init__(self, db: Session):
        self.repository = ItemRepository(db)

    def create_item(self, item_dto: ItemRequestDTO) -> ItemResponseDTO:
        item = Item(**item_dto.dict())
        created_item = self.repository.create_item(item)
        return ItemResponseDTO.model_validate(created_item)

    def get_item(self, item_id: int) -> ItemResponseDTO:
        item = self.repository.get_item_by_id(item_id)
        if not item:
            raise HTTPException(status_code=404, detail="Item not found")
        return ItemResponseDTO.model_validate(item)

    def update_item(self, item_id: int, updates: dict) -> ItemResponseDTO:
        item = self.repository.get_item_by_id(item_id)
        if not item:
            raise HTTPException(status_code=404, detail="Item not found")

        for key, value in updates.items():
            setattr(item, key, value)

        updated_item = self.repository.update_item(item)
        return ItemResponseDTO.model_validate(updated_item)

    def delete_item(self, item_id: int) -> None:
        item = self.repository.get_item_by_id(item_id)
        if not item:
            raise HTTPException(status_code=404, detail="Item not found")
        self.repository.delete_item_by_id(item_id)
```

### 7. **SQLAlchemy Entity**
Define database model in `entities.py`:

```python
from sqlalchemy import Column, Integer, Sequence, Text, TIMESTAMP, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()


class Item(Base):
    __tablename__ = 'items'

    id = Column(Integer, Sequence("items_seq"), primary_key=True)
    name = Column(Text, nullable=False)
    description = Column(Text)
    quantity = Column(Integer, nullable=False)
    is_active = Column(Boolean, default=True)
    created_on = Column(TIMESTAMP(timezone=True), default=func.now())
    updated_on = Column(TIMESTAMP(timezone=True), onupdate=func.now())

    def __repr__(self):
        return f"<Item(id={self.id}, name={self.name})>"
```

### 8. **Register Router in main.py**
Add the router to your FastAPI app:

```python
from app.controllers.item_controller import router as item_router

def add_endpoints(app: FastAPI):
    # ... existing routers
    app.include_router(item_router, prefix="/api")
```

### 9. **Best Practices**

**Dependency Injection:**
- Use `Annotated` types for cleaner dependency declarations
- Create reusable dependency aliases (`db_dep`, `user_dep`, `admin_dep`)
- Inject `Session` for database access and `User` for authentication

**Error Handling:**
- Use `HTTPException` with appropriate status codes
- Return 404 for not found resources
- Return 204 for successful deletions
- Return 400 for validation errors

**Validation:**
- Use Pydantic Field validators for request DTOs
- Validate input early in the controller
- Use `BaseModelIgnore` to ignore extra fields

**Database Operations:**
- Always commit after modifications
- Use `refresh()` to get updated data after commit
- Handle transactions properly in services

**Security:**
- Use role-based access control (`is_user_or_up`, `is_admin_or_up`)
- Protect sensitive endpoints with appropriate dependencies
- Validate user permissions in service layer if needed

**Response Models:**
- Use `response_model` parameter for automatic validation
- Use `PaginatedResponseDTO` for list endpoints
- Include timestamps (`created_on`, `updated_on`)

### 9. **Common Patterns**

**Query Parameters:**
Use the shared `QueryParams` DTO for pagination and filtering:
```python
class QueryParams(BaseModelIgnore):
    page: int = 0
    page_size: int = 10
    search: Optional[str] = None
    order_by: str = "id"
    order: str = "desc"
```

**Generic Multi-Request:**
For batch operations:
```python
class GenericMultiRequestDTO(BaseModelIgnore):
    ids: list[int]

@router.delete("/items", status_code=204)
def delete_items(request: GenericMultiRequestDTO, db: db_dep, current_user: admin_dep):
    service = ItemService(db)
    service.delete_items(request.ids)
```

**Relationships:**
When entities have relationships, use `relationship()` and nested DTOs:
```python
# In entities.py
class Item(Base):
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship("User")

# In response_dtos.py
class ItemResponseDTO(BaseModel):
    id: int
    name: str
    user: UserResponseDTO  # Nested DTO
```

## Output

Generate production-ready FastAPI code with:
1. **Controller** - FastAPI router with CRUD endpoints
2. **Service** - Business logic with database operations
3. **Repository** - Database access layer for complex queries
4. **Request DTOs** - Pydantic models for input validation
5. **Response DTOs** - Pydantic models for output serialization
6. **Entity** - SQLAlchemy ORM model
7. **Router registration** - Code snippet for main.py

All code should follow the established patterns from the existing codebase.
