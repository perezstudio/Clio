//
//  PageStore.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Observable
class PageStore {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD Operations

    /// Creates a new page
    func createPage(title: String, workspace: Workspace?, folder: Folder? = nil) -> Page {
        let page = Page(title: title, workspace: workspace, folder: folder)
        modelContext.insert(page)
        try? modelContext.save()
        return page
    }

    /// Fetches all pages for a workspace
    func fetchPages(for workspace: Workspace) -> [Page] {
        // Use relationship navigation instead of predicate
        return workspace.pages
            .filter { $0.folder == nil }
            .sorted { $0.lastUpdatedDate > $1.lastUpdatedDate }
    }

    /// Fetches pages in a folder
    func fetchPages(in folder: Folder) -> [Page] {
        return folder.pages.sorted { $0.lastUpdatedDate > $1.lastUpdatedDate }
    }

    /// Fetches all pages (for "All Workspaces" view)
    func fetchAllPages() -> [Page] {
        let descriptor = FetchDescriptor<Page>(
            sortBy: [SortDescriptor(\.lastUpdatedDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Updates a page's title and automatically updates lastUpdatedDate
    func updatePageTitle(_ page: Page, title: String) {
        page.title = title
        page.updateTimestamp()
        try? modelContext.save()
    }

    /// Updates the page's last updated timestamp
    func updatePageTimestamp(_ page: Page) {
        page.updateTimestamp()
        try? modelContext.save()
    }

    /// Moves a page to a different folder
    func movePage(_ page: Page, to folder: Folder?) {
        page.folder = folder
        page.updateTimestamp()
        try? modelContext.save()
    }

    /// Deletes a page
    func deletePage(_ page: Page) {
        modelContext.delete(page)
        try? modelContext.save()
    }
}
