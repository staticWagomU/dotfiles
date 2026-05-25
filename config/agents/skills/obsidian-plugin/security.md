# Security Patterns

Obsidian plugins run with full filesystem access. Security is non-negotiable.

## DOM Manipulation: CRITICAL RULES

### NEVER Use These with User Input

```typescript
// ❌ DANGEROUS - XSS vulnerability
element.innerHTML = userInput;
element.outerHTML = userInput;
element.insertAdjacentHTML('beforeend', userInput);
```

These methods parse strings as HTML, enabling script injection attacks.

### ALWAYS Build DOM Programmatically

```typescript
// ✅ SAFE - Use Obsidian's helpers
const container = containerEl.createDiv({ cls: 'my-plugin-container' });
const title = container.createEl('h2', { text: 'Settings' });
const paragraph = container.createEl('p', { text: userInput }); // Safe!

// ✅ SAFE - createSpan for inline elements
const badge = container.createSpan({ cls: 'status-badge', text: status });
```

### Safe DOM Helpers

| Method | Use Case |
|--------|----------|
| `createEl(tag, options)` | Create any HTML element |
| `createDiv(options)` | Create div container |
| `createSpan(options)` | Create inline element |
| `setText(text)` | Set text content safely |
| `empty()` | Clear element contents |

### Options Object

```typescript
interface DomElementOptions {
    cls?: string | string[];      // CSS classes
    text?: string;                 // Text content (safe)
    attr?: Record<string, string>; // Attributes
    title?: string;                // Tooltip
    parent?: HTMLElement;          // Parent to append to
}
```

## User Path Handling

Always normalize user-provided paths:

```typescript
// ❌ BAD - User paths may have invalid characters
const path = userInput + '/note.md';
this.app.vault.create(path, content);

// ✅ GOOD - Normalize first
import { normalizePath } from 'obsidian';
const path = normalizePath(userInput + '/note.md');
this.app.vault.create(path, content);
```

## File Content Safety

When displaying file contents in UI:

```typescript
// ❌ BAD - File may contain malicious HTML
containerEl.innerHTML = await this.app.vault.read(file);

// ✅ GOOD - Use MarkdownRenderer for .md files
await MarkdownRenderer.renderMarkdown(
    content,
    containerEl,
    file.path,
    this
);

// ✅ GOOD - Or create text elements for plain text
containerEl.createEl('pre', { text: content });
```

## Settings Validation

Always validate settings before use:

```typescript
// ✅ Validate on load
async loadSettings() {
    const data = await this.loadData();
    this.settings = Object.assign({}, DEFAULT_SETTINGS, data);

    // Validate critical paths
    if (this.settings.templateFolder) {
        this.settings.templateFolder = normalizePath(
            this.settings.templateFolder
        );
    }
}
```

## Event Handler Safety

Validate data in event callbacks:

```typescript
this.registerEvent(
    this.app.vault.on('rename', (file, oldPath) => {
        // ✅ Type check before using
        if (!(file instanceof TFile)) return;
        if (file.extension !== 'md') return;

        // Now safe to process
        this.handleRename(file, oldPath);
    })
);
```
