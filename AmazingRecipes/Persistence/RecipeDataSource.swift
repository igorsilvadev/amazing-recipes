//
//  RecipeDataSource.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 27/07/23.
//

import Foundation
import CoreData

protocol RecipeDataSource {
    var context: NSManagedObjectContext { get set}
    func getAll() -> [Recipe]
    func getByName(name: String) -> Recipe?
    func delete(recipe: Recipe)
    func create(desc: String?, image: Data?, preparationTime: Int16, price: Double, title: String?)
}


class RecipeDataSourceManager: RecipeDataSource {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAll() -> [Recipe] {
        do {
            let recipes = try context.fetch(Recipe.fetchRequest())
            return recipes
        } catch {
            return []
        }
    }
    
    func getByName(name: String) -> Recipe? {
        let request = Recipe.fetchRequest()
        let predicate = NSPredicate(format: "title == %@", name)
        request.predicate = predicate
        do {
            let recipes = try context.fetch(request)
            return recipes.first
        } catch {
            return nil
        }
    }
    
    func delete(recipe: Recipe) {
        do {
            context.delete(recipe)
            try context.save()
        } catch {
            context.rollback()
            print("Erro ao deletar")
        }
    }
    
    func create(desc: String?, image: Data?, preparationTime: Int16, price: Double, title: String?) {
        let recipe = Recipe(context: context)
        recipe.desc = desc
        recipe.title = title
        recipe.price = price
        recipe.timestamp = Date()
        recipe.preparationTime = preparationTime
        recipe.image = image
    }
    
    
}
