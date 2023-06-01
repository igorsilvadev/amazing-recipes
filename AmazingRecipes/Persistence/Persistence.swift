//
//  Persistence.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    
    // Este preview é uma **computed property** que cria uma sequencia de dados fictícios apenas para uso em memória. Ele é muito útil para os previews no canvas
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        for i in 0...10 {
            let recipe = Recipe(context: controller.container.viewContext)
            recipe.title = "Receita \(i)"
            recipe.desc = "Modo de preparo para receita \(i)"
            recipe.preparationTime = Int16(10)
            recipe.price = 10.0
            let ingredient = Ingredient(context: controller.container.viewContext)
            ingredient.name = "Ingrediente para receita \(i)"
            recipe.addToIngredients(ingredient)
            recipe.timestamp = Date()
        }
        
        return controller
    }()

    //MARK: Core Data Container
    // Esse container faz o gerenciamento do armazenamento do app. Nele vai exister o view context para as operações de CRUD
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Aqui ocorre a inicialização do container informando o nome do arquivo que contém o modelo das entidades e relacionamentos
        container = NSPersistentContainer(name: "AmazingRecipes")
        
        // Essa condicional permite criar uma versão em memória dos dados, ou seja, assim que o app encerrar esses dados deixam de existir. Isso é útil para utilizar o preview do Canvas ou para não precisar apagar o app a cada compilação e execução.
        if inMemory {
            // O caminho /dev/null passa um local inválido para o armazenamento permanente, evitando assim que os dados sejam salvos após o encerramento do app.
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        
        // Você deve chamar esse método para fazer o loading da store e permitir a criação da stack do core data com os dados
        container.loadPersistentStores(completionHandler: { nsDescription, loadError in
            // Aqui você pode executar alguma lógica necessária após o loading da store
            
            //⚠️ É importante conferir se o loadError contém nil, para garantir que não ocorreu nenhum problema no carregamento
        })
        
        
        
        
        
        //⚠️ Se você está iniciando ainda não precisa se preocupar com esse trecho.
        
        /* Quando o automaticallyMergesChangesFromParent está definido como true para o viewContext, qualquer alteração feita nos contextos pais será automaticamente mesclada no viewContext.
         Isso significa que se um contexto pai fizer alterações em objetos gerenciados (managed objects), como criar, atualizar ou excluir objetos, essas alterações serão refletidas automaticamente no viewContext e, portanto, na interface do usuário.
         */
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
