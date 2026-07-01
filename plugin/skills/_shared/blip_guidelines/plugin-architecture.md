# Blip Plugin Architecture

This document describes the architectural standards for building Blip React plugins, based on the official templates and reference projects.

## 1. Iframe Message Proxy
Blip plugins run inside an iframe within the Blip portal. All communication with the parent portal (like showing toast notifications, getting user tokens, or resizing the window) must be done via `iframe-message-proxy`.

### Initialization
The iframe must be initialized early (e.g., in `src/lib/setup/iframe.js`) to expand and take the remaining height of the portal:
```javascript
import { IframeMessageProxy } from 'iframe-message-proxy';

IframeMessageProxy.listen();

// The iframe's parent minimum height is 100%. By setting its height to 0px,
// the extension will take 100% of the remaining height.
void IframeMessageProxy.sendMessage({
  action: 'heightChange',
  content: 0,
});
```

## 2. Global Setup Structure
Instead of bloating `index.js`, separate all setup scripts inside `src/lib/setup/` and import them in the entry point:
- `src/lib/setup/blip-ds.js`
- `src/lib/setup/fonts.js`
- `src/lib/setup/i18n.js`
- `src/lib/setup/iframe.js`

## 3. Routing
Use **React Router v6**. Implement routing using `createBrowserRouter` and `RouterProvider`. Ensure that a root `Layout` component wraps all children for consistent page structures, and an `ErrorPage` is mapped for fallbacks.

## 4. Internationalization (i18n)
Plugins must be built with i18n from day one, using `react-i18next`. Setup translations using `i18next` and ensure the language syncs with the Blip portal configuration (usually passed during the plugin load).

## 5. Testing
Use **Cypress** for component testing instead of standard Jest DOM testing where possible. Coverage reporting is configured via `nyc` and `@cypress/code-coverage`.
