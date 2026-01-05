//
//  WorkspaceStore.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Observable
class WorkspaceStore {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD Operations

    /// Creates a new workspace
    func createWorkspace(name: String) -> Workspace {
        let workspace = Workspace(name: name)
        modelContext.insert(workspace)
        try? modelContext.save()
        return workspace
    }

    /// Fetches all workspaces
    func fetchWorkspaces() -> [Workspace] {
        let descriptor = FetchDescriptor<Workspace>(
            sortBy: [SortDescriptor(\.createdDate)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Updates a workspace's name
    func updateWorkspace(_ workspace: Workspace, name: String) {
        workspace.name = name
        try? modelContext.save()
    }

    /// Deletes a workspace
    func deleteWorkspace(_ workspace: Workspace) {
        modelContext.delete(workspace)
        try? modelContext.save()
    }
}
