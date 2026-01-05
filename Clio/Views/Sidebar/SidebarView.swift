//
//  SidebarView.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedPage: Page?

    @State private var workspaceStore: WorkspaceStore?
    @State private var folderStore: FolderStore?
    @State private var pageStore: PageStore?

    @State private var workspaces: [Workspace] = []
    @State private var selectedWorkspace: Workspace?
    @State private var folders: [Folder] = []
    @State private var pages: [Page] = []
    @State private var showCreateWorkspace = false

    var body: some View {
        VStack(spacing: 0) {
            // Workspace chips
            WorkspaceChipsView(
                workspaces: workspaces,
                selectedWorkspace: $selectedWorkspace
            )
            .frame(height: 52)

            Divider()

            // Navigation list - fills remaining space
            NavigationListView(
                folders: folders,
                pages: pages,
                selectedPage: $selectedPage
            )
            .frame(maxHeight: .infinity)

            Divider()

            // Footer with workspace info and create button
            SidebarFooterView(
                selectedWorkspace: selectedWorkspace,
                onCreateWorkspace: {
                    showCreateWorkspace = true
                }
            )
            .frame(height: 50)
        }
        .background(.ultraThinMaterial)
        .onAppear {
            setupStores()
            loadWorkspaces()
        }
        .onChange(of: selectedWorkspace) { _, _ in
            loadNavigationItems()
        }
        .sheet(isPresented: $showCreateWorkspace) {
            CreateWorkspaceSheet(onSave: { name in
                createWorkspace(name: name)
            })
        }
    }

    private func setupStores() {
        workspaceStore = WorkspaceStore(modelContext: modelContext)
        folderStore = FolderStore(modelContext: modelContext)
        pageStore = PageStore(modelContext: modelContext)
    }

    private func loadWorkspaces() {
        guard let store = workspaceStore else { return }
        workspaces = store.fetchWorkspaces()
        selectedWorkspace = nil // "All Workspaces"
        loadNavigationItems()
    }

    private func loadNavigationItems() {
        guard let folderStore = folderStore, let pageStore = pageStore else { return }

        if let workspace = selectedWorkspace {
            folders = folderStore.fetchFolders(for: workspace)
            pages = pageStore.fetchPages(for: workspace)
        } else {
            folders = []
            pages = pageStore.fetchAllPages()
        }
    }

    private func createWorkspace(name: String) {
        guard let store = workspaceStore else { return }
        _ = store.createWorkspace(name: name)
        loadWorkspaces()
        showCreateWorkspace = false
    }
}

// MARK: - Workspace Chips View

struct WorkspaceChipsView: View {
    let workspaces: [Workspace]
    @Binding var selectedWorkspace: Workspace?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All Workspaces" chip
                WorkspaceChip(
                    title: "All Workspaces",
                    isSelected: selectedWorkspace == nil
                ) {
                    selectedWorkspace = nil
                }

                // Workspace chips
                ForEach(workspaces, id: \.id) { workspace in
                    WorkspaceChip(
                        title: workspace.name,
                        isSelected: selectedWorkspace?.id == workspace.id
                    ) {
                        selectedWorkspace = workspace
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Workspace Chip

struct WorkspaceChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color.accentColor : Color(nsColor: .controlBackgroundColor))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Navigation List View

struct NavigationListView: View {
    let folders: [Folder]
    let pages: [Page]
    @Binding var selectedPage: Page?

    var body: some View {
        List(selection: $selectedPage) {
            // Folders
            ForEach(folders, id: \.id) { folder in
                FolderRow(folder: folder, selectedPage: $selectedPage)
            }

            // Pages
            ForEach(pages, id: \.id) { page in
                PageRow(page: page)
                    .tag(page)
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Folder Row

struct FolderRow: View {
    let folder: Folder
    @Binding var selectedPage: Page?
    @State private var isExpanded: Bool = true

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            // Subfolders
            ForEach(folder.subfolders, id: \.id) { subfolder in
                FolderRow(folder: subfolder, selectedPage: $selectedPage)
            }

            // Pages in folder
            ForEach(folder.pages, id: \.id) { page in
                PageRow(page: page)
                    .tag(page)
            }
        } label: {
            Label(folder.name, systemImage: "folder")
                .font(.system(size: 13))
        }
    }
}

// MARK: - Page Row

struct PageRow: View {
    let page: Page

    var body: some View {
        Label(page.title, systemImage: "doc.text")
            .font(.system(size: 13))
    }
}

// MARK: - Sidebar Footer View

struct SidebarFooterView: View {
    let selectedWorkspace: Workspace?
    let onCreateWorkspace: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(selectedWorkspace?.name ?? "All Workspaces")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("\(selectedWorkspace == nil ? "All" : "Current") Workspace")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onCreateWorkspace) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
            .help("Create Workspace")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

// MARK: - Create Workspace Sheet

struct CreateWorkspaceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var workspaceName: String = ""
    let onSave: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Workspace")
                .font(.headline)

            TextField("Workspace Name", text: $workspaceName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)

            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Button("Create") {
                    if !workspaceName.isEmpty {
                        onSave(workspaceName)
                        dismiss()
                    }
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
                .disabled(workspaceName.isEmpty)
            }
        }
        .padding(24)
        .frame(width: 400, height: 180)
    }
}
