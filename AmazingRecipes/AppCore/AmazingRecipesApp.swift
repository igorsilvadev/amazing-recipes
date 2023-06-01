//
//  AmazingRecipesApp.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import SwiftUI

@main
struct AmazingRecipesApp: App {
    // Ao utilizar o 'shared' os dados serão persistidos após encerramento do app.
    // Caso necessite apenas enquanto o app está executando troque por .preview
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RecipesListView()
            // Adicionamos o viewContext como um enviroment para que todas as views possam acessá-lo e realizar as operações de CRUD
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
