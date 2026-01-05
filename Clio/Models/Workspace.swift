//
//  Workspace.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Model
final class Workspace {
    var id: UUID
    var name: String
    var createdDate: Date

    @Relationship(deleteRule: .cascade, inverse: \Folder.workspace)
    var folders: [Folder]

    @Relationship(deleteRule: .cascade, inverse: \Page.workspace)
    var pages: [Page]

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.folders = []
        self.pages = []
    }
}
