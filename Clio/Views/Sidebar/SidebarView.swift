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

    var body: some View {
        VStack(spacing: 0) {
            // Workspace chips
            WorkspaceChipsView(
                workspaces: workspaces,
                selectedWorkspace: $selectedWorkspace
            )
            .frame(height: 52)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Navigation list
            NavigationListView(
                folders: folders,
                pages: pages,
                selectedPage: $selectedPage
            )
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .onAppear {
            setupStores()
            loadWorkspaces()
        }
        .onChange(of: selectedWorkspace) { _, _ in
            loadNavigationItems()
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
