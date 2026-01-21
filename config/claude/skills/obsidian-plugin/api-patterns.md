# Obsidian API Patterns

## Workspace Patterns

### Getting Active Note

```typescript
// ❌ DEPRECATED
const leaf = this.app.workspace.activeLeaf;
const view = leaf?.view;

// ✅ CURRENT - Type-safe view access
import { MarkdownView } from 'obsidian';

const view = this.app.workspace.getActiveViewOfType(MarkdownView);
if (view) {
    const file = view.file;
    const editor = view.editor;
}
```

### Getting Active Editor

```typescript
// ✅ Direct editor access (best for commands)
const editor = this.app.workspace.activeEditor?.editor;
if (editor) {
    const selection = editor.getSelection();
    editor.replaceSelection(newText);
}
```

### Iterating Leaves

```typescript
// Iterate all markdown views
this.app.workspace.iterateAllLeaves((leaf) => {
    if (leaf.view instanceof MarkdownView) {
        // Process view
    }
});
```

## Vault Patterns

### Finding Files

```typescript
// ❌ BAD - Iterating all files
const files = this.app.vault.getAllLoadedFiles();
const target = files.find(f => f.path === 'some/path.md');

// ✅ GOOD - Direct lookup
const file = this.app.vault.getFileByPath('some/path.md');
if (file instanceof TFile) {
    // Use file
}
```

### File Operations

```typescript
// Reading
const content = await this.app.vault.read(file);
const cached = await this.app.vault.cachedRead(file); // Faster, may be stale

// Creating
const newFile = await this.app.vault.create(
    normalizePath('folder/new-note.md'),
    'Initial content'
);

// Modifying - Use process() for background edits
await this.app.vault.process(file, (content) => {
    return content.replace('old', 'new');
});
```

### When to Use Each API

| Task | API | Why |
|------|-----|-----|
| Active note editing | `Editor` | Real-time updates, undo support |
| Background processing | `Vault.process()` | No view needed, atomic |
| Frontmatter changes | `FileManager.processFrontMatter()` | Handles YAML safely |

## Frontmatter Editing

```typescript
// ❌ BAD - Manual YAML parsing
const content = await this.app.vault.read(file);
const yaml = parseYaml(content);
// ... modify and rewrite entire file

// ✅ GOOD - Use FileManager
await this.app.fileManager.processFrontMatter(file, (frontmatter) => {
    frontmatter.tags = frontmatter.tags || [];
    frontmatter.tags.push('new-tag');
    frontmatter.modified = new Date().toISOString();
});
```

## Editor Patterns

```typescript
// Get current selection
const selection = editor.getSelection();

// Replace selection
editor.replaceSelection('new text');

// Get/set cursor
const cursor = editor.getCursor();
editor.setCursor({ line: 0, ch: 0 });

// Get line content
const line = editor.getLine(cursor.line);

// Insert at position
editor.replaceRange('inserted', { line: 5, ch: 0 });

// Get entire document
const doc = editor.getValue();
```

## Event Patterns

### File Events

```typescript
// File created
this.registerEvent(
    this.app.vault.on('create', (file) => {
        if (file instanceof TFile) {
            console.log('Created:', file.path);
        }
    })
);

// File modified
this.registerEvent(
    this.app.vault.on('modify', (file) => { ... })
);

// File renamed (includes moves)
this.registerEvent(
    this.app.vault.on('rename', (file, oldPath) => { ... })
);

// File deleted
this.registerEvent(
    this.app.vault.on('delete', (file) => { ... })
);
```

### Workspace Events

```typescript
// Active leaf changed
this.registerEvent(
    this.app.workspace.on('active-leaf-change', (leaf) => { ... })
);

// File opened
this.registerEvent(
    this.app.workspace.on('file-open', (file) => { ... })
);

// Layout changed
this.registerEvent(
    this.app.workspace.on('layout-change', () => { ... })
);
```

## Metadata Cache

For fast access to parsed note data:

```typescript
// Get cached metadata (frontmatter, links, etc.)
const cache = this.app.metadataCache.getFileCache(file);
if (cache) {
    const tags = cache.tags?.map(t => t.tag);
    const links = cache.links?.map(l => l.link);
    const frontmatter = cache.frontmatter;
    const headings = cache.headings;
}

// Wait for cache to be ready
this.registerEvent(
    this.app.metadataCache.on('resolved', () => {
        // All files indexed
    })
);

// React to metadata changes
this.registerEvent(
    this.app.metadataCache.on('changed', (file, data, cache) => {
        // File metadata updated
    })
);
```

## Command Registration

```typescript
this.addCommand({
    id: 'unique-command-id',
    name: 'Human readable name',
    // Simple callback
    callback: () => {
        this.doSomething();
    },
    // Or with editor context
    editorCallback: (editor, view) => {
        const selection = editor.getSelection();
        editor.replaceSelection(transform(selection));
    },
    // Optional: keyboard shortcut
    hotkeys: [{ modifiers: ['Mod'], key: 'j' }]
});
```

## Ribbon Icon

```typescript
this.addRibbonIcon('dice', 'My Plugin', (evt) => {
    // Handle click
    new Notice('Clicked!');
});
```
