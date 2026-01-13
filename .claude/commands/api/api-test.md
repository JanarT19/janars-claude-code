---
description: Test API endpoints with automated test generation
model: claude-sonnet-4-5
---

Generate comprehensive API tests for the specified endpoint.

## Target

$ARGUMENTS

## Test Strategy

**FIRST**: Detect the project type to provide appropriate testing approach:
- Check for `requirements.txt` / `pyproject.toml` → FastAPI/Python
- Check for `package.json` with `"next"` dependency → Next.js
- Check for `package.json` without Next.js → React/Node.js

Create practical, maintainable tests using framework-specific best practices.

## FastAPI Testing (Python + pytest)

### 1. **Testing Tools**
- **pytest** - Python testing framework
- **pytest-asyncio** - Async test support
- **httpx** - HTTP client for testing
- **TestClient** from FastAPI - Built-in test client
- **faker** (optional) - Generate realistic test data

### 2. **Test Structure**

**Fixture Setup:**
```python
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.config.database import Base, get_db
from app.models.entities import User, Item

# Test database
SQLALCHEMY_TEST_DATABASE_URL = "postgresql://user:pass@localhost/test_db"
engine = create_engine(SQLALCHEMY_TEST_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="function")
def db_session():
    """Create fresh database for each test"""
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def client(db_session):
    """Test client with database override"""
    def override_get_db():
        try:
            yield db_session
        finally:
            db_session.close()

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


@pytest.fixture
def auth_headers(client, db_session):
    """Create authenticated user and return headers"""
    # Create test user
    user = User(username="testuser", email="test@example.com")
    user.hash_password("password123")
    db_session.add(user)
    db_session.commit()

    # Login and get token
    response = client.post("/api/signin", json={
        "email": "test@example.com",
        "password": "password123"
    })
    token = response.json()["token"]
    return {"Authorization": f"Bearer {token}"}
```

**Test File:**
```python
import pytest
from fastapi import status


class TestItemEndpoints:
    """Test suite for /api/items endpoints"""

    def test_get_items_success(self, client, auth_headers):
        """Test GET /api/items returns paginated items"""
        response = client.get("/api/items", headers=auth_headers)

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert "elements" in data
        assert "total" in data
        assert "page" in data
        assert "page_size" in data

    def test_get_items_with_search(self, client, auth_headers, db_session):
        """Test GET /api/items with search parameter"""
        # Create test data
        item1 = Item(name="Apple", description="Fruit")
        item2 = Item(name="Banana", description="Fruit")
        db_session.add_all([item1, item2])
        db_session.commit()

        response = client.get("/api/items?search=Apple", headers=auth_headers)

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert len(data["elements"]) == 1
        assert data["elements"][0]["name"] == "Apple"

    def test_create_item_success(self, client, auth_headers):
        """Test POST /api/items creates new item"""
        payload = {
            "name": "Test Item",
            "description": "Test description",
            "quantity": 10,
            "is_active": True
        }

        response = client.post("/api/items", json=payload, headers=auth_headers)

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert data["name"] == payload["name"]
        assert data["quantity"] == payload["quantity"]
        assert "id" in data
        assert "created_on" in data

    def test_create_item_validation_error(self, client, auth_headers):
        """Test POST /api/items validates required fields"""
        payload = {"name": ""}  # Invalid: empty name

        response = client.post("/api/items", json=payload, headers=auth_headers)

        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY

    def test_get_item_by_id(self, client, auth_headers, db_session):
        """Test GET /api/items/{id} returns specific item"""
        # Create test item
        item = Item(name="Test", description="Test", quantity=5)
        db_session.add(item)
        db_session.commit()

        response = client.get(f"/api/items/{item.id}", headers=auth_headers)

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert data["id"] == item.id
        assert data["name"] == "Test"

    def test_get_item_not_found(self, client, auth_headers):
        """Test GET /api/items/{id} returns 404 for non-existent item"""
        response = client.get("/api/items/99999", headers=auth_headers)

        assert response.status_code == status.HTTP_404_NOT_FOUND

    def test_update_item(self, client, auth_headers, db_session):
        """Test PUT /api/items/{id} updates item"""
        # Create test item
        item = Item(name="Old Name", description="Old", quantity=5)
        db_session.add(item)
        db_session.commit()

        payload = {"name": "New Name", "quantity": 10}
        response = client.put(f"/api/items/{item.id}", json=payload, headers=auth_headers)

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert data["name"] == "New Name"
        assert data["quantity"] == 10

    def test_delete_item(self, client, auth_headers, db_session):
        """Test DELETE /api/items/{id} removes item"""
        # Create test item
        item = Item(name="To Delete", description="Test", quantity=1)
        db_session.add(item)
        db_session.commit()
        item_id = item.id

        response = client.delete(f"/api/items/{item_id}", headers=auth_headers)

        assert response.status_code == status.HTTP_204_NO_CONTENT

        # Verify deletion
        get_response = client.get(f"/api/items/{item_id}", headers=auth_headers)
        assert get_response.status_code == status.HTTP_404_NOT_FOUND

    def test_unauthorized_access(self, client):
        """Test endpoints require authentication"""
        response = client.get("/api/items")

        assert response.status_code == status.HTTP_401_UNAUTHORIZED
```

**Run tests:**
```bash
# Install test dependencies
pip install pytest pytest-asyncio httpx

# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_item_controller.py

# Run specific test
pytest tests/test_item_controller.py::TestItemEndpoints::test_create_item_success
```

## Next.js/TypeScript Testing

### 1. **Testing Tools**
- **Vitest** or **Jest** - Test runner
- **Supertest** - HTTP assertions
- **MSW** - API mocking

### 2. **Test Structure**

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import request from 'supertest'

describe('API: /api/items', () => {
  describe('GET /api/items', () => {
    it('should return paginated items', async () => {
      const response = await request('/api')
        .get('/items')
        .expect(200)

      expect(response.body).toHaveProperty('data')
      expect(response.body).toHaveProperty('success', true)
    })
  })

  describe('POST /api/items', () => {
    it('should create new item with valid data', async () => {
      const payload = {
        name: 'Test Item',
        quantity: 10
      }

      const response = await request('/api')
        .post('/items')
        .send(payload)
        .expect(201)

      expect(response.body.data).toMatchObject(payload)
      expect(response.body.data).toHaveProperty('id')
    })

    it('should reject invalid data', async () => {
      const payload = { name: '' }

      const response = await request('/api')
        .post('/items')
        .send(payload)
        .expect(400)

      expect(response.body.success).toBe(false)
      expect(response.body).toHaveProperty('error')
    })
  })
})
```

**Run tests:**
```bash
npm test
# or
npm run test:watch
```

## Universal Test Coverage

### 1. **Happy Paths**
- Valid inputs return expected results
- Proper status codes (200, 201, 204)
- Correct response structure

### 2. **Error Paths**
- Invalid input validation (400, 422)
- Authentication failures (401)
- Authorization failures (403)
- Not found (404)
- Server errors (500)
- Missing required fields

### 3. **Edge Cases**
- Empty requests
- Malformed JSON
- Large payloads
- Special characters in strings
- SQL injection attempts
- XSS attempts
- Boundary values (min/max)

### 4. **Security Testing**
- **Authentication**: Valid/expired/missing tokens
- **Authorization**: Role-based access control
- **Input Validation**: Type mismatches, injection attacks
- **Rate Limiting**: Within/exceeding limits

## Key Testing Principles

- **Arrange-Act-Assert pattern** - Clear test structure
- **Independent tests** - No shared state between tests
- **Test behavior, not implementation** - Focus on outcomes
- **Clear, descriptive names** - Tests as documentation
- **Fast execution** - Unit tests < 5s, integration tests < 30s
- **Realistic test data** - Mirror production scenarios
- **Test error messages** - Verify error handling
- **Clean up after tests** - Reset database/state
- Don't mock what you don't own
- Don't test framework internals

## Output

Generate production-ready test code with:
1. **Test file** - Complete test suite with all scenarios
2. **Fixtures/setup** - Database and authentication helpers
3. **Mock data** - Realistic test fixtures
4. **Run instructions** - Commands to execute tests

All tests should follow the project's existing patterns and conventions.
