# Claude Instructions for Clio Project

## Project Context
This is a macOS note-taking application similar to Notion, built with SwiftData and AppKit using a Model-Store-View architecture.

## Build Verification Requirements

**IMPORTANT**: Before marking any implementation task as completed, you MUST:

1. **Build the application** using `xcodebuild` or the appropriate build command
2. **Verify the build succeeds** without errors
3. **Fix any compilation errors** that arise from your changes
4. **Only mark the task as done** once the build is successful

### Build Command
```bash
xcodebuild -project Clio.xcodeproj -scheme Clio -configuration Debug build
```
or
```bash
xcodebuild -workspace Clio.xcworkspace -scheme Clio -configuration Debug build
```
(Use whichever is appropriate for the project structure)

### Workflow for Each Task
1. Implement the feature/modification
2. Run the build command
3. If build fails:
   - Analyze the errors
   - Fix the issues
   - Rebuild until successful
4. Only after successful build, mark the task as completed

## Code Standards

- **Architecture**: Maintain strict Model-Store-View separation
- **SwiftData**: Ensure proper relationships and delete rules
- **AppKit**: Use native AppKit components where possible
- **Page Metadata**: Always update `lastUpdatedDate` when page or block content changes
- **Error Handling**: Implement proper error handling for all CRUD operations
- **Performance**: Consider performance for pages with many blocks

## Testing Requirements

- Test each feature after implementation
- Verify UI updates correctly reflect data changes
- Ensure proper memory management (no retain cycles)
- Test edge cases (empty states, deletions, etc.)

## Documentation

- Add inline comments for complex logic
- Update this instructions file if new build processes are added
- Keep the project-plan.md checklist updated with progress
