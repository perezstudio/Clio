//
//  Page.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Model
final class Page {
    var id: UUID
    var title: String
    var createdDate: Date
    var lastUpdatedDate: Date

    var workspace: Workspace?
    var folder: Folder?

    @Relationship(deleteRule: .cascade, inverse: \Block.page)
    var blocks: [Block]

    init(title: String, workspace: Workspace? = nil, folder: Folder? = nil) {
        self.id = UUID()
        self.title = title
        self.createdDate = Date()
        self.lastUpdatedDate = Date()
        self.workspace = workspace
        self.folder = folder
        self.blocks = []
    }

    /// Updates the lastUpdatedDate to the current time
    func updateTimestamp() {
        self.lastUpdatedDate = Date()
    }
}
