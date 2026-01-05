//
//  MainContentView.swift
//  Clio
//
//  Created by Claude on 1/4/26.
//

import SwiftUI
import SwiftData

struct MainContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPage: Page?

    var body: some View {
        AppKitSplitView(
            sidebar: {
                SidebarView(selectedPage: $selectedPage)
            },
            content: {
                ContentAreaView(selectedPage: selectedPage)
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
