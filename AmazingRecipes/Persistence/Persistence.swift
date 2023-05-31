//
//  Persistence.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        for i in 0...10 {
            let recipe = Recipe(context: controller.container.viewContext)
            recipe.title = "Recipe \(i)"
            recipe.timestamp = Date()
        }
        
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AmazingRecipes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        // Você deve chamar esse método para fazer o loading da store e permitir a criação da stack do core data com os dados
        container.loadPersistentStores(completionHandler: { nsDescription, loadError in
            // Aqui você pode executar alguma lógica necessária após o loading da store
            
            //⚠️ É importante conferir se o loadError contém nil, para garantir que não ocorreu nenhum problema no carregamento
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
