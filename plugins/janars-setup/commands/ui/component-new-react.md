---
description: Create a new React component with Material-UI
model: claude-sonnet-4-5
---

Create a new React component following Material-UI (MUI) best practices.

## Requirements

Component Specification: $ARGUMENTS

## Implementation Guidelines

### 1. **Component Structure**
Organize components in the `src/helper-components/` directory:
- `form/` - Form-related components (inputs, selectors, steppers)
- `input/` - Input components (text fields, checkboxes, etc.)
- `table/` - Table and data grid components
- `misc/` - Miscellaneous utility components
- `pages/` - Full page components

### 2. **Component Template**

**Basic Component:**
```jsx
import React from 'react';
import { Box, Typography } from '@mui/material';

export default function ComponentName({ prop1, prop2, ...props }) {
    return (
        <Box sx={{ /* styles */ }}>
            <Typography variant="h6">
                Component Content
            </Typography>
        </Box>
    );
}
```

**Component with State:**
```jsx
import React, { useState, useEffect } from 'react';
import { Box, Button, TextField } from '@mui/material';

export default function ComponentName({ initialValue, onSave }) {
    const [value, setValue] = useState(initialValue || '');

    useEffect(() => {
        // Side effects here
    }, [value]);

    const handleSave = () => {
        if (onSave) {
            onSave(value);
        }
    };

    return (
        <Box>
            <TextField
                value={value}
                onChange={(e) => setValue(e.target.value)}
                fullWidth
            />
            <Button onClick={handleSave} variant="contained">
                Save
            </Button>
        </Box>
    );
}
```

### 3. **Material-UI Patterns**

**Using sx prop for styling:**
```jsx
<Box
    sx={{
        display: 'flex',
        flexDirection: 'column',
        gap: 2,
        p: 3,
        bgcolor: 'background.paper',
        borderRadius: 1
    }}
>
    {/* content */}
</Box>
```

**Responsive Design:**
```jsx
<Box
    sx={{
        width: { xs: '100%', sm: '80%', md: '60%' },
        p: { xs: 2, md: 4 }
    }}
>
    {/* content */}
</Box>
```

**Theme Integration:**
```jsx
import { useTheme } from '@mui/material/styles';

export default function ComponentName() {
    const theme = useTheme();

    return (
        <Box
            sx={{
                color: theme.palette.primary.main,
                backgroundColor: theme.palette.background.default
            }}
        >
            {/* content */}
        </Box>
    );
}
```

### 4. **Common MUI Components**

**Form Components:**
```jsx
import {
    TextField,
    Select,
    MenuItem,
    FormControl,
    InputLabel,
    Checkbox,
    FormControlLabel,
    Button
} from '@mui/material';

<TextField
    label="Name"
    value={value}
    onChange={handleChange}
    fullWidth
    required
    error={!!error}
    helperText={error}
/>

<FormControl fullWidth>
    <InputLabel>Category</InputLabel>
    <Select value={category} onChange={handleCategoryChange}>
        <MenuItem value="option1">Option 1</MenuItem>
        <MenuItem value="option2">Option 2</MenuItem>
    </Select>
</FormControl>

<FormControlLabel
    control={<Checkbox checked={isChecked} onChange={handleCheck} />}
    label="Accept terms"
/>
```

**Layout Components:**
```jsx
import { Container, Grid, Paper, Card, CardContent } from '@mui/material';

<Container maxWidth="lg">
    <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
            <Paper sx={{ p: 2 }}>
                <Typography variant="h6">Section</Typography>
            </Paper>
        </Grid>
    </Grid>
</Container>

<Card>
    <CardContent>
        <Typography variant="h5" component="div">
            Card Title
        </Typography>
        <Typography variant="body2">
            Card content
        </Typography>
    </CardContent>
</Card>
```

**Data Display:**
```jsx
import { DataGrid } from '@mui/x-data-grid';

const columns = [
    { field: 'id', headerName: 'ID', width: 90 },
    { field: 'name', headerName: 'Name', width: 150 },
    { field: 'email', headerName: 'Email', width: 200 }
];

<DataGrid
    rows={rows}
    columns={columns}
    pageSize={10}
    checkboxSelection
    disableSelectionOnClick
/>
```

**Dialogs and Modals:**
```jsx
import { Dialog, DialogTitle, DialogContent, DialogActions } from '@mui/material';

<Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
    <DialogTitle>Dialog Title</DialogTitle>
    <DialogContent>
        {/* Dialog content */}
    </DialogContent>
    <DialogActions>
        <Button onClick={handleClose}>Cancel</Button>
        <Button onClick={handleSave} variant="contained">Save</Button>
    </DialogActions>
</Dialog>
```

**Notifications:**
```jsx
import { useSnackbar } from 'notistack';

export default function ComponentName() {
    const { enqueueSnackbar } = useSnackbar();

    const handleSuccess = () => {
        enqueueSnackbar('Operation successful!', { variant: 'success' });
    };

    const handleError = () => {
        enqueueSnackbar('Something went wrong', { variant: 'error' });
    };

    // ... rest of component
}
```

### 5. **State Management Patterns**

**Local State:**
```jsx
const [formData, setFormData] = useState({
    name: '',
    email: '',
    age: 0
});

const handleInputChange = (field) => (event) => {
    setFormData(prev => ({
        ...prev,
        [field]: event.target.value
    }));
};
```

**Form Validation:**
```jsx
const [errors, setErrors] = useState({});

const validate = () => {
    const newErrors = {};

    if (!formData.name) {
        newErrors.name = 'Name is required';
    }
    if (!formData.email.includes('@')) {
        newErrors.email = 'Invalid email';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
};

const handleSubmit = (e) => {
    e.preventDefault();
    if (validate()) {
        // Submit form
    }
};
```

### 6. **API Integration**

**Fetching Data:**
```jsx
import { useState, useEffect } from 'react';

export default function ComponentName() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('/api/items');
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

    if (loading) return <CircularProgress />;
    if (error) return <Alert severity="error">{error}</Alert>;

    return (
        <Box>
            {/* Render data */}
        </Box>
    );
}
```

**Posting Data:**
```jsx
const handleSubmit = async (formData) => {
    try {
        const response = await fetch('/api/items', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify(formData)
        });

        if (!response.ok) throw new Error('Failed to save');

        const result = await response.json();
        enqueueSnackbar('Saved successfully!', { variant: 'success' });
        return result;
    } catch (err) {
        enqueueSnackbar(err.message, { variant: 'error' });
    }
};
```

### 7. **Common Patterns**

**Loading States:**
```jsx
import { CircularProgress, Box } from '@mui/material';

{loading ? (
    <Box display="flex" justifyContent="center" p={3}>
        <CircularProgress />
    </Box>
) : (
    <DataContent />
)}
```

**Conditional Rendering:**
```jsx
{items.length > 0 ? (
    <List>
        {items.map(item => (
            <ListItem key={item.id}>{item.name}</ListItem>
        ))}
    </List>
) : (
    <Typography variant="body2" color="text.secondary">
        No items found
    </Typography>
)}
```

**Event Handlers:**
```jsx
// Inline arrow function (for simple handlers)
<Button onClick={() => handleClick(id)}>Click</Button>

// Named function (for complex handlers)
const handleDelete = (id) => {
    if (window.confirm('Are you sure?')) {
        deleteItem(id);
    }
};
<Button onClick={() => handleDelete(item.id)}>Delete</Button>
```

### 8. **Best Practices**

**Component Organization:**
- Keep components focused and single-purpose
- Extract reusable logic into custom hooks
- Use prop destructuring for cleaner code
- Provide default props where appropriate

**Performance:**
- Use React.memo() for expensive components
- Memoize callbacks with useCallback when passing to children
- Avoid inline object/array creation in render

**Accessibility:**
- Use semantic HTML elements
- Provide aria-labels for interactive elements
- Ensure keyboard navigation works
- Test with screen readers

**Styling:**
- Prefer sx prop over inline styles
- Use theme values for consistency
- Keep responsive design in mind
- Use MUI breakpoints: xs, sm, md, lg, xl

**Error Handling:**
- Always handle loading and error states
- Show user-friendly error messages
- Use notistack for notifications
- Log errors for debugging

## Output

Generate production-ready React component code with:
1. **Component file** - Complete .jsx file with imports
2. **Props documentation** - Clear prop descriptions and types
3. **Usage example** - How to use the component
4. **MUI integration** - Proper use of Material-UI components
5. **Responsive design** - Mobile-first approach

All code should follow the established patterns from the existing codebase and Material-UI best practices.
