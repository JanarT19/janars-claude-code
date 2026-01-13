---
description: Create a new React page component with routing
model: claude-sonnet-4-5
---

Create a new React page component with react-router-dom integration and Material-UI.

## Requirements

Page Specification: $ARGUMENTS

## Implementation Guidelines

### 1. **Page Structure**
React pages are typically placed in:
- `src/pages/` - Main application pages
- `src/helper-components/pages/` - Utility pages (404, error pages, loaders)

### 2. **Basic Page Template**

**Simple Page:**
```jsx
import React from 'react';
import { Container, Typography, Box } from '@mui/material';

export default function PageName() {
    return (
        <Container maxWidth="lg">
            <Box sx={{ py: 4 }}>
                <Typography variant="h4" gutterBottom>
                    Page Title
                </Typography>
                <Typography variant="body1">
                    Page content goes here
                </Typography>
            </Box>
        </Container>
    );
}
```

**Page with Data Fetching:**
```jsx
import React, { useState, useEffect } from 'react';
import {
    Container,
    Typography,
    Box,
    CircularProgress,
    Alert
} from '@mui/material';

export default function PageName() {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('/api/data');
                if (!response.ok) throw new Error('Failed to fetch');
                const result = await response.json();
                setData(result);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="60vh">
                <CircularProgress />
            </Box>
        );
    }

    if (error) {
        return (
            <Container maxWidth="md">
                <Box sx={{ py: 4 }}>
                    <Alert severity="error">{error}</Alert>
                </Box>
            </Container>
        );
    }

    return (
        <Container maxWidth="lg">
            <Box sx={{ py: 4 }}>
                <Typography variant="h4" gutterBottom>
                    Page Title
                </Typography>
                {/* Render data */}
            </Box>
        </Container>
    );
}
```

### 3. **React Router Integration**

**Page with URL Parameters:**
```jsx
import { useParams, useNavigate } from 'react-router-dom';

export default function ItemDetailPage() {
    const { id } = useParams();
    const navigate = useNavigate();

    const handleBack = () => {
        navigate('/items');
    };

    return (
        <Container maxWidth="lg">
            <Box sx={{ py: 4 }}>
                <Button onClick={handleBack} startIcon={<ArrowBackIcon />}>
                    Back to List
                </Button>
                <Typography variant="h4" gutterBottom>
                    Item Details (ID: {id})
                </Typography>
                {/* Content */}
            </Box>
        </Container>
    );
}
```

**Page with Navigation:**
```jsx
import { useNavigate, Link } from 'react-router-dom';
import { Button, Breadcrumbs, Link as MuiLink } from '@mui/material';

export default function PageName() {
    const navigate = useNavigate();

    const handleCreate = () => {
        navigate('/items/new');
    };

    return (
        <Container maxWidth="lg">
            <Box sx={{ py: 4 }}>
                <Breadcrumbs sx={{ mb: 2 }}>
                    <MuiLink component={Link} to="/" underline="hover">
                        Home
                    </MuiLink>
                    <Typography color="text.primary">Current Page</Typography>
                </Breadcrumbs>

                <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
                    <Typography variant="h4">Page Title</Typography>
                    <Button variant="contained" onClick={handleCreate}>
                        Create New
                    </Button>
                </Box>

                {/* Page content */}
            </Box>
        </Container>
    );
}
```

### 4. **Common Page Patterns**

**List Page with Table:**
```jsx
import React, { useState, useEffect } from 'react';
import {
    Container,
    Box,
    Typography,
    Button,
    TextField,
    InputAdornment
} from '@mui/material';
import { DataGrid } from '@mui/x-data-grid';
import { Search as SearchIcon, Add as AddIcon } from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';

export default function ItemListPage() {
    const navigate = useNavigate();
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [page, setPage] = useState(0);
    const [pageSize, setPageSize] = useState(10);
    const [total, setTotal] = useState(0);

    useEffect(() => {
        fetchItems();
    }, [page, pageSize, search]);

    const fetchItems = async () => {
        setLoading(true);
        try {
            const response = await fetch(
                `/api/items?page=${page}&page_size=${pageSize}&search=${search}`
            );
            const data = await response.json();
            setItems(data.elements);
            setTotal(data.total);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const columns = [
        { field: 'id', headerName: 'ID', width: 90 },
        { field: 'name', headerName: 'Name', flex: 1 },
        {
            field: 'actions',
            headerName: 'Actions',
            width: 150,
            renderCell: (params) => (
                <Button
                    size="small"
                    onClick={() => navigate(`/items/${params.row.id}`)}
                >
                    View
                </Button>
            )
        }
    ];

    return (
        <Container maxWidth="lg">
            <Box sx={{ py: 4 }}>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
                    <Typography variant="h4">Items</Typography>
                    <Button
                        variant="contained"
                        startIcon={<AddIcon />}
                        onClick={() => navigate('/items/new')}
                    >
                        Create New
                    </Button>
                </Box>

                <TextField
                    placeholder="Search..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    fullWidth
                    sx={{ mb: 2 }}
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        )
                    }}
                />

                <DataGrid
                    rows={items}
                    columns={columns}
                    loading={loading}
                    pagination
                    page={page}
                    pageSize={pageSize}
                    rowCount={total}
                    paginationMode="server"
                    onPageChange={setPage}
                    onPageSizeChange={setPageSize}
                    rowsPerPageOptions={[10, 25, 50]}
                    autoHeight
                    disableSelectionOnClick
                />
            </Box>
        </Container>
    );
}
```

**Form Page:**
```jsx
import React, { useState } from 'react';
import {
    Container,
    Box,
    Typography,
    TextField,
    Button,
    Paper,
    Grid
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useSnackbar } from 'notistack';

export default function ItemFormPage() {
    const navigate = useNavigate();
    const { enqueueSnackbar } = useSnackbar();

    const [formData, setFormData] = useState({
        name: '',
        description: '',
        quantity: 0
    });

    const [errors, setErrors] = useState({});

    const handleChange = (field) => (event) => {
        setFormData(prev => ({
            ...prev,
            [field]: event.target.value
        }));
        // Clear error when user types
        if (errors[field]) {
            setErrors(prev => ({ ...prev, [field]: '' }));
        }
    };

    const validate = () => {
        const newErrors = {};

        if (!formData.name) {
            newErrors.name = 'Name is required';
        }
        if (formData.quantity < 0) {
            newErrors.quantity = 'Quantity must be positive';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!validate()) return;

        try {
            const response = await fetch('/api/items', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error('Failed to save');

            enqueueSnackbar('Item created successfully!', { variant: 'success' });
            navigate('/items');
        } catch (err) {
            enqueueSnackbar(err.message, { variant: 'error' });
        }
    };

    return (
        <Container maxWidth="md">
            <Box sx={{ py: 4 }}>
                <Typography variant="h4" gutterBottom>
                    Create New Item
                </Typography>

                <Paper sx={{ p: 3, mt: 3 }}>
                    <form onSubmit={handleSubmit}>
                        <Grid container spacing={3}>
                            <Grid item xs={12}>
                                <TextField
                                    label="Name"
                                    value={formData.name}
                                    onChange={handleChange('name')}
                                    error={!!errors.name}
                                    helperText={errors.name}
                                    fullWidth
                                    required
                                />
                            </Grid>

                            <Grid item xs={12}>
                                <TextField
                                    label="Description"
                                    value={formData.description}
                                    onChange={handleChange('description')}
                                    multiline
                                    rows={4}
                                    fullWidth
                                />
                            </Grid>

                            <Grid item xs={12} sm={6}>
                                <TextField
                                    label="Quantity"
                                    type="number"
                                    value={formData.quantity}
                                    onChange={handleChange('quantity')}
                                    error={!!errors.quantity}
                                    helperText={errors.quantity}
                                    fullWidth
                                />
                            </Grid>

                            <Grid item xs={12}>
                                <Box display="flex" gap={2} justifyContent="flex-end">
                                    <Button
                                        variant="outlined"
                                        onClick={() => navigate('/items')}
                                    >
                                        Cancel
                                    </Button>
                                    <Button
                                        type="submit"
                                        variant="contained"
                                    >
                                        Save
                                    </Button>
                                </Box>
                            </Grid>
                        </Grid>
                    </form>
                </Paper>
            </Box>
        </Container>
    );
}
```

**Detail/View Page:**
```jsx
import React, { useState, useEffect } from 'react';
import {
    Container,
    Box,
    Typography,
    Button,
    Paper,
    Grid,
    Divider,
    CircularProgress
} from '@mui/material';
import { useParams, useNavigate } from 'react-router-dom';
import { Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material';
import { useSnackbar } from 'notistack';

export default function ItemDetailPage() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { enqueueSnackbar } = useSnackbar();

    const [item, setItem] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchItem();
    }, [id]);

    const fetchItem = async () => {
        try {
            const response = await fetch(`/api/items/${id}`);
            if (!response.ok) throw new Error('Item not found');
            const data = await response.json();
            setItem(data);
        } catch (err) {
            enqueueSnackbar(err.message, { variant: 'error' });
            navigate('/items');
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async () => {
        if (!window.confirm('Are you sure you want to delete this item?')) {
            return;
        }

        try {
            const response = await fetch(`/api/items/${id}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Failed to delete');

            enqueueSnackbar('Item deleted successfully', { variant: 'success' });
            navigate('/items');
        } catch (err) {
            enqueueSnackbar(err.message, { variant: 'error' });
        }
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="60vh">
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Container maxWidth="md">
            <Box sx={{ py: 4 }}>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
                    <Typography variant="h4">Item Details</Typography>
                    <Box display="flex" gap={2}>
                        <Button
                            variant="outlined"
                            startIcon={<EditIcon />}
                            onClick={() => navigate(`/items/${id}/edit`)}
                        >
                            Edit
                        </Button>
                        <Button
                            variant="outlined"
                            color="error"
                            startIcon={<DeleteIcon />}
                            onClick={handleDelete}
                        >
                            Delete
                        </Button>
                    </Box>
                </Box>

                <Paper sx={{ p: 3 }}>
                    <Grid container spacing={2}>
                        <Grid item xs={12}>
                            <Typography variant="overline" color="text.secondary">
                                Name
                            </Typography>
                            <Typography variant="h6">{item.name}</Typography>
                        </Grid>

                        <Grid item xs={12}>
                            <Divider />
                        </Grid>

                        <Grid item xs={12}>
                            <Typography variant="overline" color="text.secondary">
                                Description
                            </Typography>
                            <Typography variant="body1">{item.description || 'N/A'}</Typography>
                        </Grid>

                        <Grid item xs={12} sm={6}>
                            <Typography variant="overline" color="text.secondary">
                                Quantity
                            </Typography>
                            <Typography variant="body1">{item.quantity}</Typography>
                        </Grid>

                        <Grid item xs={12} sm={6}>
                            <Typography variant="overline" color="text.secondary">
                                Created On
                            </Typography>
                            <Typography variant="body1">
                                {new Date(item.created_on).toLocaleString()}
                            </Typography>
                        </Grid>
                    </Grid>
                </Paper>
            </Box>
        </Container>
    );
}
```

### 5. **Routing Setup**

**Add route in App.jsx:**
```jsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import ItemListPage from './pages/ItemListPage';
import ItemDetailPage from './pages/ItemDetailPage';
import ItemFormPage from './pages/ItemFormPage';

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/items" element={<ItemListPage />} />
                <Route path="/items/new" element={<ItemFormPage />} />
                <Route path="/items/:id" element={<ItemDetailPage />} />
                <Route path="/items/:id/edit" element={<ItemFormPage />} />
            </Routes>
        </BrowserRouter>
    );
}
```

### 6. **Best Practices**

**Page Layout:**
- Use Container with consistent maxWidth (lg, md, xl)
- Add vertical padding with `py: 4` for spacing
- Keep responsive design in mind

**Loading States:**
- Show CircularProgress centered for full page loads
- Use skeleton loaders for partial updates
- Disable buttons during async operations

**Error Handling:**
- Display errors with Alert components
- Use notistack for notifications
- Redirect on critical errors (404, 403)

**Navigation:**
- Use useNavigate hook for programmatic navigation
- Use Link component for declarative navigation
- Provide back buttons and breadcrumbs

**Data Fetching:**
- Fetch data in useEffect
- Handle loading and error states
- Clean up subscriptions/aborts on unmount

## Output

Generate production-ready React page code with:
1. **Page component** - Complete .jsx file with routing integration
2. **Data fetching** - API integration with loading/error states
3. **Form handling** - If applicable, with validation
4. **Navigation** - Proper routing and navigation patterns
5. **MUI components** - Consistent Material-UI usage

All code should follow react-router-dom v6 patterns and Material-UI best practices.
