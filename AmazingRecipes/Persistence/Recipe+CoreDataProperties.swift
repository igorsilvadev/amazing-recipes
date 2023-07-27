//
//  Recipe+CoreDataProperties.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 27/07/23.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var preparationTime: Int16
    @NSManaged public var price: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var ingredients: NSSet?
    
    var wrappedIngredients: [Ingredient] {
        self.ingredients?.allObjects as? [Ingredient] ?? []
    }

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Recipe : Identifiable {

}
