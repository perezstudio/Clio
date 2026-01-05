# Clio - Notion-like Note-Taking App

## Project Overview
A macOS-focused note-taking application inspired by Notion, featuring workspaces, folders, pages, and block-based content editing with markdown support.

## Architecture
- **Pattern**: Model-Store-View
- **Storage**: SwiftData
- **UI Framework**: AppKit (macOS native)

---

## Implementation Plan

### Phase 1: Data Layer (SwiftData Models)
- Define `Workspace`, `Folder`, `Page` models with proper relationships
- **Page model properties**:
  - `title: String`
  - `createdDate: Date`
  - `lastUpdatedDate: Date`
- Create `Block` base model with subclasses for each block type:
  - TextBlock
  - HeadingBlock (levels 1-6)
  - BulletedListBlock
  - NumberedListBlock
  - TodoListBlock
  - ToggleListBlock
  - CalloutBlock
  - QuoteBlock
  - TableBlock
  - DividerBlock
  - PageLinkBlock
- Set up nested relationships: Workspace → Folders/Pages → Blocks
- Configure SwiftData schema with proper delete rules and auto-update timestamps

### Phase 2: Business Logic (Stores)
- Implement Store layer following Model-Store-View architecture
- `WorkspaceStore`: Manage workspace CRUD operations
- `FolderStore`: Handle folder hierarchy and nesting
- `PageStore`: Manage page operations, auto-update `lastUpdatedDate` on changes
- `BlockStore`: Handle block operations (add, delete, reorder, update)

### Phase 3: Main Window & Split View
- Create main AppKit window with `NSSplitViewController`
- Configure vertical split with collapsible sidebar
- Set up proper constraints and sizing behavior

### Phase 4: Sidebar Implementation
- Build horizontal `NSScrollView` for workspace chips/tabs
- Implement "All Workspaces" default view
- Create tree-based navigation using `NSOutlineView` for folders/pages
- Display page titles in navigation tree
- Add icons and styling for different item types

### Phase 5: Block-Based Editor
- Display page title, created date, and last updated date at top of content area
- Design `BlockView` protocol and base implementation
- Create individual view components for each block type
- Implement block insertion, deletion, and reordering
- Add keyboard shortcuts for block manipulation (⌘+/, etc.)

### Phase 6: Markdown Support
- Integrate markdown parser (e.g., Down or swift-markdown)
- Implement markdown → blocks conversion
- Add live markdown syntax support in text blocks
- Support markdown export functionality

### Phase 7: Integration & Polish
- Wire up selection/navigation between sidebar and content area
- Auto-update `lastUpdatedDate` when page content changes
- Implement search functionality
- Add keyboard navigation and shortcuts
- Polish UI with proper macOS styling

---

## Implementation Checklist

### Data Models & SwiftData Setup
- [ ] Create `Workspace` model
- [ ] Create `Folder` model with parent-child relationships
- [ ] Create `Page` model with `title`, `createdDate`, `lastUpdatedDate`
- [ ] Create base `Block` model
- [ ] Create `TextBlock` model
- [ ] Create `HeadingBlock` model (H1-H6)
- [ ] Create `BulletedListBlock` model
- [ ] Create `NumberedListBlock` model
- [ ] Create `TodoListBlock` model
- [ ] Create `ToggleListBlock` model
- [ ] Create `CalloutBlock` model
- [ ] Create `QuoteBlock` model
- [ ] Create `TableBlock` model
- [ ] Create `DividerBlock` model
- [ ] Create `PageLinkBlock` model
- [ ] Configure SwiftData schema and relationships
- [ ] Set up delete cascade rules
- [ ] Implement auto-timestamp updates

### Store Layer
- [ ] Create `WorkspaceStore` with CRUD operations
- [ ] Create `FolderStore` with hierarchy management
- [ ] Create `PageStore` with automatic `lastUpdatedDate` tracking
- [ ] Create `BlockStore` with add/delete/reorder operations
- [ ] Add observers/publishers for data changes

### Main Window & Layout
- [ ] Create main `NSWindow` and `NSWindowController`
- [ ] Set up `NSSplitViewController` with vertical split
- [ ] Configure sidebar pane (collapsible)
- [ ] Configure content pane
- [ ] Set up Auto Layout constraints
- [ ] Configure split view sizing and behaviors

### Sidebar UI
- [ ] Create workspace horizontal scroll view
- [ ] Implement workspace chip/tab UI components
- [ ] Add "All Workspaces" default workspace
- [ ] Create `NSOutlineView` for folder/page tree
- [ ] Implement outline view data source
- [ ] Implement outline view delegate
- [ ] Add icons for workspaces, folders, pages
- [ ] Style sidebar with macOS native appearance
- [ ] Add context menus for items (right-click)

### Content Area - Page Header
- [ ] Create page header view
- [ ] Display page title (editable)
- [ ] Display created date
- [ ] Display last updated date
- [ ] Style header appropriately

### Block System - Core
- [ ] Design `BlockView` protocol
- [ ] Create base `BlockViewController` or view component
- [ ] Implement block container view
- [ ] Add block insertion UI (+ button, slash commands)
- [ ] Implement block deletion
- [ ] Implement block reordering (drag & drop)
- [ ] Add block type selector menu

### Block System - Individual Block Types
- [ ] Implement `TextBlock` view
- [ ] Implement `HeadingBlock` view (H1-H6 variants)
- [ ] Implement `BulletedListBlock` view
- [ ] Implement `NumberedListBlock` view
- [ ] Implement `TodoListBlock` view with checkbox
- [ ] Implement `ToggleListBlock` view with disclosure triangle
- [ ] Implement `CalloutBlock` view with icon and background
- [ ] Implement `QuoteBlock` view with border/styling
- [ ] Implement `TableBlock` view with rows/columns
- [ ] Implement `DividerBlock` view (horizontal line)
- [ ] Implement `PageLinkBlock` view with navigation

### Markdown Support
- [ ] Add markdown parser dependency (Down/swift-markdown)
- [ ] Implement markdown parsing to block conversion
- [ ] Add markdown syntax highlighting in text blocks
- [ ] Implement live markdown rendering
- [ ] Add markdown shortcuts (**, __, [], etc.)
- [ ] Implement export to markdown functionality
- [ ] Add import from markdown functionality

### Navigation & Integration
- [ ] Wire sidebar selection to content area
- [ ] Implement page loading when selected
- [ ] Handle workspace switching
- [ ] Implement folder expansion/collapse
- [ ] Add breadcrumb navigation (optional)
- [ ] Implement back/forward navigation (optional)

### CRUD Operations
- [ ] Create new workspace
- [ ] Delete workspace
- [ ] Rename workspace
- [ ] Create new folder
- [ ] Delete folder (with confirmation)
- [ ] Rename folder
- [ ] Move folders (drag & drop)
- [ ] Create new page
- [ ] Delete page (with confirmation)
- [ ] Rename page (update title)
- [ ] Move pages between folders

### Keyboard Shortcuts & UX
- [ ] Add ⌘+N for new page
- [ ] Add ⌘+/ for block type menu
- [ ] Add ⌘+B for bold (in text blocks)
- [ ] Add ⌘+I for italic (in text blocks)
- [ ] Add ⌘+K for link insertion
- [ ] Add Tab/Shift+Tab for indentation
- [ ] Add arrow key navigation between blocks
- [ ] Add Enter to create new block
- [ ] Add Backspace on empty block to delete
- [ ] Add ⌘+D to duplicate block

### Search & Additional Features
- [ ] Implement global search functionality
- [ ] Add search UI in sidebar or toolbar
- [ ] Search across page titles
- [ ] Search within page content
- [ ] Highlight search results

### Polish & Styling
- [ ] Apply macOS Big Sur+ styling
- [ ] Implement dark mode support
- [ ] Add smooth animations and transitions
- [ ] Polish focus states and selection
- [ ] Add empty states for new workspaces/pages
- [ ] Implement proper error handling and alerts
- [ ] Add loading states where needed
- [ ] Performance optimization for large documents

### Testing & Documentation
- [ ] Write unit tests for models
- [ ] Write unit tests for stores
- [ ] Write UI tests for main workflows
- [ ] Add inline code documentation
- [ ] Create user documentation (if needed)

---

## Notes
- Focus on AppKit for native macOS experience
- Maintain clean Model-Store-View separation
- Ensure proper SwiftData relationship management
- Auto-update `lastUpdatedDate` on any page/block modification
- Consider performance for pages with many blocks
