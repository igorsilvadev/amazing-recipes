//
//  RecipesListView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import SwiftUI
import CoreData

struct RecipesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddItem = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)],
        animation: .default)
    private var recipes: FetchedResults<Recipe>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(recipes) { recipe in
                        NavigationLink {
                            RecipeInfoView(recipe: recipe)
                        } label: {
                            Text(recipe.title ?? "")
                        }
                    }
                    .onDelete(perform: deleteRecipes)
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        EditButton()
                    }
                    
                }
            }
            .sheet(isPresented: $showAddItem) {
                CreateRecipeView()
            }
        }
    }
    
    private func addItem() {
        showAddItem = true
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipes[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
