//
//  WindowAccessor.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.callback(view.window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            self.callback(nsView.window)
        }
    }
}

extension View {
    func configureWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(WindowAccessor(callback: callback))
    }
}
