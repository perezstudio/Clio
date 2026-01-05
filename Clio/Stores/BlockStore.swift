//
//  BlockStore.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import Foundation
import SwiftData

@Observable
class BlockStore {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD Operations

    /// Creates a new block and updates the page timestamp
    func createBlock(type: BlockType, content: String = "", page: Page, at index: Int? = nil) -> Block {
        let order = index ?? page.blocks.count
        let block = Block(type: type, content: content, order: order, page: page)

        modelContext.insert(block)
        page.updateTimestamp()

        // Reorder blocks if inserting at a specific index
        if let index = index {
            reorderBlocks(in: page, startingFrom: index)
        }

        try? modelContext.save()
        return block
    }

    /// Fetches all blocks for a page, sorted by order
    func fetchBlocks(for page: Page) -> [Block] {
        return page.blocks.sorted { $0.order < $1.order }
    }

    /// Updates a block's content and updates the page timestamp
    func updateBlock(_ block: Block, content: String) {
        block.content = content
        block.page?.updateTimestamp()
        try? modelContext.save()
    }

    /// Updates a block's type
    func updateBlockType(_ block: Block, type: BlockType) {
        block.type = type
        block.page?.updateTimestamp()
        try? modelContext.save()
    }

    /// Updates heading level for heading blocks
    func updateHeadingLevel(_ block: Block, level: Int) {
        guard (1...6).contains(level) else { return }
        block.headingLevel = level
        block.page?.updateTimestamp()
        try? modelContext.save()
    }

    /// Updates checked state for todo blocks
    func updateTodoChecked(_ block: Block, isChecked: Bool) {
        block.isChecked = isChecked
        block.page?.updateTimestamp()
        try? modelContext.save()
    }

    /// Updates expanded state for toggle blocks
    func updateToggleExpanded(_ block: Block, isExpanded: Bool) {
        block.isExpanded = isExpanded
        block.page?.updateTimestamp()
        try? modelContext.save()
    }

    /// Deletes a block and updates the page timestamp
    func deleteBlock(_ block: Block) {
        guard let page = block.page else { return }
        let deletedOrder = block.order

        modelContext.delete(block)
        page.updateTimestamp()

        // Reorder remaining blocks
        reorderBlocks(in: page, startingFrom: deletedOrder)

        try? modelContext.save()
    }

    /// Moves a block to a new position
    func moveBlock(_ block: Block, to newIndex: Int) {
        guard let page = block.page else { return }
        let oldIndex = block.order

        if oldIndex == newIndex { return }

        block.order = newIndex

        // Reorder other blocks
        let blocks = page.blocks.sorted { $0.order < $1.order }
        for (index, b) in blocks.enumerated() where b.id != block.id {
            if oldIndex < newIndex {
                // Moving down
                if b.order > oldIndex && b.order <= newIndex {
                    b.order -= 1
                }
            } else {
                // Moving up
                if b.order >= newIndex && b.order < oldIndex {
                    b.order += 1
                }
            }
        }

        page.updateTimestamp()
        try? modelContext.save()
    }

    // MARK: - Private Helpers

    /// Reorders blocks starting from a given index
    private func reorderBlocks(in page: Page, startingFrom index: Int) {
        let blocks = page.blocks.sorted { $0.order < $1.order }
        for (idx, block) in blocks.enumerated() {
            block.order = idx
        }
    }
}
