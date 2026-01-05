//
//  AppKitSplitView.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import SwiftUI
import AppKit

struct AppKitSplitView<Sidebar: View, Content: View>: NSViewRepresentable {
    let sidebar: () -> Sidebar
    let content: () -> Content

    func makeNSView(context: Context) -> NSSplitView {
        let splitView = NSSplitView()
        splitView.isVertical = true
        splitView.dividerStyle = .thin

        // Make split view transparent so materials work
        splitView.wantsLayer = true
        splitView.layer?.backgroundColor = .clear

        // Create sidebar container
        let sidebarHostingView = NSHostingView(rootView: sidebar())
        sidebarHostingView.autoresizingMask = [.width, .height]

        // Configure sidebar view to be transparent
        sidebarHostingView.wantsLayer = true
        sidebarHostingView.layer?.backgroundColor = .clear

        // Create content container
        let contentHostingView = NSHostingView(rootView: content())
        contentHostingView.autoresizingMask = [.width, .height]

        // Configure content view to be transparent (material is applied in SwiftUI)
        contentHostingView.wantsLayer = true
        contentHostingView.layer?.backgroundColor = .clear

        // Add views to split view
        splitView.addArrangedSubview(sidebarHostingView)
        splitView.addArrangedSubview(contentHostingView)

        // Configure sidebar constraints
        sidebarHostingView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        sidebarHostingView.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        sidebarHostingView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Configure content constraints
        contentHostingView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Set initial sidebar width
        splitView.setPosition(250, ofDividerAt: 0)

        splitView.delegate = context.coordinator
        return splitView
    }

    func updateNSView(_ nsView: NSSplitView, context: Context) {
        // Update views if needed
        if let sidebarView = nsView.arrangedSubviews.first as? NSHostingView<Sidebar> {
            sidebarView.rootView = sidebar()
        }
        if let contentView = nsView.arrangedSubviews.last as? NSHostingView<Content> {
            contentView.rootView = content()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, NSSplitViewDelegate {
        func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
            return subview == splitView.arrangedSubviews.first
        }

        func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
            return false
        }

        func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
            return 200
        }

        func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
            return 400
        }
    }
}
