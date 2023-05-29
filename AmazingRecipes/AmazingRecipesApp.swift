//
//  AmazingRecipesApp.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import SwiftUI

@main
struct AmazingRecipesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
