# Blip Design System (BDS) Guidelines

This document outlines the strict usage of the Blip Design System (`blip-ds`) when building React plugins, derived directly from reference projects (`blip-na-produtization`, `blip-stellantis-plugin`).

## 1. Setup and Initialization
Blip DS provides Web Components that must be initialized globally before rendering the React tree.
```javascript
// src/lib/setup/blip-ds.js
import { applyPolyfills, defineCustomElements } from 'blip-ds/loader';

void applyPolyfills().then(() => defineCustomElements(window));
```

## 2. Typography
The official font for Blip is **Nunito Sans**. It must be loaded via `@fontsource/nunito-sans` and applied globally.

## 3. Styling with Tailwind
Blip plugins use Tailwind CSS combined with the `tailwind-blip-ds` plugin to map BDS design tokens into Tailwind classes.
- Avoid writing raw CSS/SCSS.
- Use the design tokens provided by `tailwind-blip-ds` for colors, spacing, and typography.

Example `tailwind.config.js`:
```javascript
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
  plugins: [require('tailwind-blip-ds')],
};
```

## 4. Using Web Components in React
Because `blip-ds` relies on Web Components, when using components like `<bds-loading-page>` or `<bds-button>`, pass data using standard HTML attributes or properties. Note that React events on custom elements may require lowercase syntax or refs if passing complex objects.
