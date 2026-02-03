# p5.js Core Modules

This directory contains the non-minified core modules from p5.js, automatically generated for the p5.nvim plugin.

## Structure

- `modules/` - Core p5.js modules organized by category

- `modules.js` - Index file for importing modules
- `README.md` - This file

## Usage

### Importing specific modules:

```javascript
import { loadModule, getCategories } from './modules.js';

// Available categories
console.log(getCategories()); // ['accessibility', 'color', 'core', ...]

// Load a specific module
const p5Main = await loadModule('core', 'main');
const p5Vector = await loadModule('math', 'p5_vector');
const p5Color = await loadModule('color', 'p5_color');
```

### Importing all modules in a category:

```javascript
import { loadCategory } from './modules.js';

// Load all math modules
const mathModules = await loadCategory('math');

// Load all color modules
const colorModules = await loadCategory('color');
```

### Importing all modules:

```javascript
import { loadAll } from './modules.js';

// Load all p5.js modules
const allModules = await loadAll();
console.log(allModules.core); // All core modules
console.log(allModules.color); // All color modules
```

## Available Categories



## Generated Files

**Total modules**: 0  
**Total categories**: 0



## Module Statistics



## Generation Info

- **Source**: processing/p5.js
- **Generated**: 2026-02-03T08:59:33.178Z
- **Version**: Latest from main branch
- **Total Size**: 0 bytes

**DO NOT EDIT** - These files are automatically generated and will be overwritten on the next update.

## API Reference

See the generated `modules.js` file for the complete API:

- `modules` - Object containing all module loaders by category
- `getCategories()` - Array of available categories
- `getCategoryModules(category)` - Get modules in a specific category
- `loadModule(category, name)` - Load a specific module
- `loadCategory(category)` - Load all modules in a category
- `loadAll()` - Load all modules
- `moduleInfo` - Object with module metadata
