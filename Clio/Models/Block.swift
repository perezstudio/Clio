//
//  Block.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

/// Base block model representing a content block in a page
@Model
final class Block {
    var id: UUID
    var type: BlockType
    var content: String
    var order: Int
    var createdDate: Date

    var page: Page?

    // Additional properties for specific block types
    var headingLevel: Int? // For heading blocks (1-6)
    var isChecked: Bool? // For todo blocks
    var isExpanded: Bool? // For toggle blocks
    var calloutIcon: String? // For callout blocks
    var tableData: String? // JSON string for table data

    init(type: BlockType, content: String = "", order: Int = 0, page: Page? = nil) {
        self.id = UUID()
        self.type = type
        self.content = content
        self.order = order
        self.createdDate = Date()
        self.page = page
    }
}

/// Enum representing the different types of blocks
enum BlockType: String, Codable {
    case text
    case heading1
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
    case bulletedList
    case numberedList
    case todoList
    case toggleList
    case callout
    case quote
    case table
    case divider
    case pageLink
}
