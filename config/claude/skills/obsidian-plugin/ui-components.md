# UI Component Patterns

## Settings Tab

### Basic Structure

```typescript
export class MyPluginSettingTab extends PluginSettingTab {
    plugin: MyPlugin;

    constructor(app: App, plugin: MyPlugin) {
        super(app, plugin);
        this.plugin = plugin;
    }

    display(): void {
        const { containerEl } = this;
        containerEl.empty();

        // General settings at top (NO heading)
        new Setting(containerEl)
            .setName('Default folder')
            .setDesc('Where new notes are created')
            .addText(text => text
                .setPlaceholder('folder/path')
                .setValue(this.plugin.settings.defaultFolder)
                .onChange(async (value) => {
                    this.plugin.settings.defaultFolder = value;
                    await this.plugin.saveSettings();
                }));

        // Section heading (use setHeading for consistency)
        new Setting(containerEl)
            .setHeading()
            .setName('Advanced');  // Sentence case, no "settings"

        // Or use createEl for heading
        containerEl.createEl('h2', { text: 'Advanced' });
    }
}
```

### Setting Types

```typescript
// Toggle
new Setting(containerEl)
    .setName('Enable feature')
    .addToggle(toggle => toggle
        .setValue(this.plugin.settings.enabled)
        .onChange(async (value) => {
            this.plugin.settings.enabled = value;
            await this.plugin.saveSettings();
        }));

// Dropdown
new Setting(containerEl)
    .setName('Choose option')
    .addDropdown(dropdown => dropdown
        .addOption('a', 'Option A')
        .addOption('b', 'Option B')
        .setValue(this.plugin.settings.option)
        .onChange(async (value) => {
            this.plugin.settings.option = value;
            await this.plugin.saveSettings();
        }));

// Text area
new Setting(containerEl)
    .setName('Template')
    .addTextArea(text => text
        .setPlaceholder('Enter template...')
        .setValue(this.plugin.settings.template)
        .onChange(async (value) => {
            this.plugin.settings.template = value;
            await this.plugin.saveSettings();
        }));

// Button
new Setting(containerEl)
    .setName('Reset')
    .setDesc('Reset all settings to defaults')
    .addButton(button => button
        .setButtonText('Reset')
        .setWarning()  // Red button for destructive actions
        .onClick(async () => {
            this.plugin.settings = Object.assign({}, DEFAULT_SETTINGS);
            await this.plugin.saveSettings();
            this.display();  // Refresh UI
        }));

// Search (file/folder suggester)
new Setting(containerEl)
    .setName('Template file')
    .addSearch(search => search
        .setPlaceholder('Search files...')
        .setValue(this.plugin.settings.templateFile)
        .onChange(async (value) => {
            this.plugin.settings.templateFile = value;
            await this.plugin.saveSettings();
        }));
```

### Heading Guidelines

| Rule | Example |
|------|---------|
| General settings at top | No heading needed |
| Sentence case | "Advanced" not "Advanced Settings" |
| Avoid redundant "settings" | "Advanced" not "Advanced settings" |
| Use `setHeading()` | For consistent styling |

## Modals

### Basic Modal

```typescript
export class MyModal extends Modal {
    result: string;
    onSubmit: (result: string) => void;

    constructor(app: App, onSubmit: (result: string) => void) {
        super(app);
        this.onSubmit = onSubmit;
    }

    onOpen() {
        const { contentEl } = this;

        contentEl.createEl('h2', { text: 'Enter value' });

        new Setting(contentEl)
            .setName('Value')
            .addText(text => text
                .onChange((value) => {
                    this.result = value;
                }));

        new Setting(contentEl)
            .addButton(btn => btn
                .setButtonText('Submit')
                .setCta()  // Primary action styling
                .onClick(() => {
                    this.close();
                    this.onSubmit(this.result);
                }));
    }

    onClose() {
        const { contentEl } = this;
        contentEl.empty();
    }
}

// Usage
new MyModal(this.app, (result) => {
    console.log('User entered:', result);
}).open();
```

### Suggest Modal (Fuzzy Search)

```typescript
export class FileSuggestModal extends FuzzySuggestModal<TFile> {
    onChoose: (file: TFile) => void;

    constructor(app: App, onChoose: (file: TFile) => void) {
        super(app);
        this.onChoose = onChoose;
    }

    getItems(): TFile[] {
        return this.app.vault.getMarkdownFiles();
    }

    getItemText(file: TFile): string {
        return file.path;
    }

    onChooseItem(file: TFile, evt: MouseEvent | KeyboardEvent) {
        this.onChoose(file);
    }
}

// Usage
new FileSuggestModal(this.app, (file) => {
    console.log('Selected:', file.path);
}).open();
```

### Confirmation Modal

```typescript
export class ConfirmModal extends Modal {
    message: string;
    onConfirm: () => void;

    constructor(app: App, message: string, onConfirm: () => void) {
        super(app);
        this.message = message;
        this.onConfirm = onConfirm;
    }

    onOpen() {
        const { contentEl } = this;

        contentEl.createEl('p', { text: this.message });

        new Setting(contentEl)
            .addButton(btn => btn
                .setButtonText('Cancel')
                .onClick(() => this.close()))
            .addButton(btn => btn
                .setButtonText('Confirm')
                .setWarning()
                .onClick(() => {
                    this.close();
                    this.onConfirm();
                }));
    }

    onClose() {
        this.contentEl.empty();
    }
}
```

## Custom Views

### View Registration

```typescript
const VIEW_TYPE_EXAMPLE = 'example-view';

export default class MyPlugin extends Plugin {
    async onload() {
        this.registerView(
            VIEW_TYPE_EXAMPLE,
            (leaf) => new ExampleView(leaf)
        );

        this.addRibbonIcon('layout-dashboard', 'Open view', () => {
            this.activateView();
        });
    }

    async activateView() {
        const { workspace } = this.app;

        let leaf = workspace.getLeavesOfType(VIEW_TYPE_EXAMPLE)[0];
        if (!leaf) {
            const rightLeaf = workspace.getRightLeaf(false);
            if (rightLeaf) {
                leaf = rightLeaf;
                await leaf.setViewState({
                    type: VIEW_TYPE_EXAMPLE,
                    active: true
                });
            }
        }
        if (leaf) {
            workspace.revealLeaf(leaf);
        }
    }
}
```

### View Implementation

```typescript
export class ExampleView extends ItemView {
    getViewType() {
        return VIEW_TYPE_EXAMPLE;
    }

    getDisplayText() {
        return 'Example view';
    }

    getIcon() {
        return 'layout-dashboard';
    }

    async onOpen() {
        const container = this.containerEl.children[1];
        container.empty();
        container.createEl('h4', { text: 'Example view' });

        // Build your UI here using safe DOM methods
        const content = container.createDiv({ cls: 'my-plugin-content' });
        content.createEl('p', { text: 'View content goes here' });
    }

    async onClose() {
        // Cleanup if needed
    }
}
```

## Styling

### Use CSS Variables

```css
/* ✅ GOOD - Uses Obsidian's theme variables */
.my-plugin-container {
    background-color: var(--background-primary);
    color: var(--text-normal);
    border: 1px solid var(--background-modifier-border);
    padding: var(--size-4-2);
    border-radius: var(--radius-s);
}

.my-plugin-heading {
    color: var(--text-accent);
    font-size: var(--font-ui-large);
    margin-bottom: var(--size-4-2);
}

.my-plugin-muted {
    color: var(--text-muted);
    font-size: var(--font-ui-small);
}

/* ❌ BAD - Hardcoded colors break themes */
.my-plugin-container {
    background-color: #ffffff;
    color: #333333;
    border: 1px solid #cccccc;
}
```

### Common CSS Variables

| Variable | Use |
|----------|-----|
| `--background-primary` | Main background |
| `--background-secondary` | Sidebar, secondary areas |
| `--background-modifier-border` | Borders |
| `--text-normal` | Body text |
| `--text-muted` | Secondary text |
| `--text-accent` | Links, highlights |
| `--interactive-accent` | Buttons, selections |
| `--font-ui-small` | Small text |
| `--font-ui-medium` | Normal text |
| `--font-ui-large` | Large text |
| `--size-4-1` through `--size-4-8` | Spacing |
| `--radius-s`, `--radius-m`, `--radius-l` | Border radius |

### CSS Class Naming

Use plugin-prefixed class names to avoid conflicts:

```typescript
// ✅ GOOD - Prefixed with plugin name
containerEl.createDiv({ cls: 'my-actual-plugin-container' });

// ❌ BAD - Generic or placeholder names
containerEl.createDiv({ cls: 'container' });
containerEl.createDiv({ cls: 'sample-plugin-container' });
```

## Notices

```typescript
// Simple notice (auto-dismiss)
new Notice('Operation completed!');

// Longer notice
new Notice('This will take a while...', 5000);  // 5 seconds

// Fragment notice (styled content)
const fragment = document.createDocumentFragment();
const b = fragment.createEl('b', { text: 'Success: ' });
fragment.appendText('File created');
new Notice(fragment);
```
