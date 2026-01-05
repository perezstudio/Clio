//
//  ClioApp.swift
//  Clio
//
//  Created by Kevin Perez on 1/4/26.
//

import SwiftUI
import SwiftData

@main
struct ClioApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workspace.self,
            Folder.self,
            Page.self,
            Block.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            // Keep standard commands
            CommandGroup(replacing: .newItem) { }
        }
    }
}
