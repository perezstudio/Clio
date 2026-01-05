//
//  Folder.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Model
final class Folder {
    var id: UUID
    var name: String
    var createdDate: Date

    var workspace: Workspace?

    @Relationship(deleteRule: .cascade, inverse: \Folder.parentFolder)
    var subfolders: [Folder]

    var parentFolder: Folder?

    @Relationship(deleteRule: .cascade, inverse: \Page.folder)
    var pages: [Page]

    init(name: String, workspace: Workspace? = nil, parentFolder: Folder? = nil) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.workspace = workspace
        self.parentFolder = parentFolder
        self.subfolders = []
        self.pages = []
    }
}
