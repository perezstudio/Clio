//
//  ContentAreaView.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import SwiftUI
import SwiftData

struct ContentAreaView: View {
    let selectedPage: Page?

    var body: some View {
        if let page = selectedPage {
            PageEditorView(page: page)
        } else {
            EmptyStateView()
        }
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No Page Selected")
                .font(.title2)
                .foregroundColor(.primary)

            Text("Select a page from the sidebar to start editing")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .textBackgroundColor))
    }
}

// MARK: - Page Editor View

struct PageEditorView: View {
    @Environment(\.modelContext) private var modelContext
    let page: Page

    @State private var blockStore: BlockStore?
    @State private var blocks: [Block] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Page header
                PageHeaderView(page: page)

                // Blocks
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(blocks, id: \.id) { block in
                        BlockView(block: block)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .textBackgroundColor))
        .onAppear {
            setupStore()
            loadBlocks()
        }
    }

    private func setupStore() {
        blockStore = BlockStore(modelContext: modelContext)
    }

    private func loadBlocks() {
        guard let store = blockStore else { return }
        blocks = store.fetchBlocks(for: page)
    }
}

// MARK: - Page Header View

struct PageHeaderView: View {
    let page: Page

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Text("Created:")
                        .foregroundColor(.secondary)
                    Text(page.createdDate, style: .date)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 4) {
                    Text("Last Updated:")
                        .foregroundColor(.secondary)
                    Text(page.lastUpdatedDate, style: .date)
                        .foregroundColor(.secondary)
                }
            }
            .font(.system(size: 12))
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Block View (Placeholder)

struct BlockView: View {
    let block: Block

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)

            Text(block.content.isEmpty ? "Empty block" : block.content)
                .foregroundColor(block.content.isEmpty ? .secondary : .primary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(4)
    }

    private var iconName: String {
        switch block.type {
        case .text: return "text.alignleft"
        case .heading1, .heading2, .heading3, .heading4, .heading5, .heading6: return "textformat.size"
        case .bulletedList: return "list.bullet"
        case .numberedList: return "list.number"
        case .todoList: return "checkmark.square"
        case .toggleList: return "chevron.right"
        case .callout: return "info.circle"
        case .quote: return "quote.opening"
        case .table: return "tablecells"
        case .divider: return "minus"
        case .pageLink: return "link"
        }
    }
}
