//
//  FolderStore.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Observable
class FolderStore {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD Operations

    /// Creates a new folder
    func createFolder(name: String, workspace: Workspace?, parentFolder: Folder? = nil) -> Folder {
        let folder = Folder(name: name, workspace: workspace, parentFolder: parentFolder)
        modelContext.insert(folder)
        try? modelContext.save()
        return folder
    }

    /// Fetches all folders for a workspace
    func fetchFolders(for workspace: Workspace) -> [Folder] {
        // Use relationship navigation instead of predicate
        return workspace.folders
            .filter { $0.parentFolder == nil }
            .sorted { $0.name < $1.name }
    }

    /// Fetches subfolders of a parent folder
    func fetchSubfolders(of parentFolder: Folder) -> [Folder] {
        return parentFolder.subfolders.sorted { $0.name < $1.name }
    }

    /// Updates a folder's name
    func updateFolder(_ folder: Folder, name: String) {
        folder.name = name
        try? modelContext.save()
    }

    /// Moves a folder to a different parent
    func moveFolder(_ folder: Folder, to newParent: Folder?) {
        folder.parentFolder = newParent
        try? modelContext.save()
    }

    /// Deletes a folder
    func deleteFolder(_ folder: Folder) {
        modelContext.delete(folder)
        try? modelContext.save()
    }
}
