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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.timestamp, ascending: true)])
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
            .navigationTitle("Lista de Receitas")
        }
    }
    
    private func addItem() {
        showAddItem = true
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            
            offsets.map { recipes[$0] }.forEach { recipe in
                viewContext.delete(recipe)
            }
            
            do {
                try viewContext.save()
            } catch {
               // Aqui você criar um tratamento para caso ocorra um erro ao salvar as alterações.
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
