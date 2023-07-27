//
//  RecipesListView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 28/05/23.
//

import SwiftUI
import CoreData

struct RecipesListView: View {

    var dataSource: RecipeDataSource
    @State private var showAddItem = false
    @State var recipes: [Recipe] = []
    
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
            .sheet(isPresented: $showAddItem, onDismiss: {
                fetchRecipes()
            }) {
                CreateRecipeView()
            }
            .navigationTitle("Lista de Receitas")
            .onAppear {
                fetchRecipes()
            }
        }
    }
    
    private func fetchRecipes() {
        recipes = dataSource.getAll()
    }
    
    private func addItem() {
        showAddItem = true
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipes[$0] }.forEach { recipe in
                dataSource.delete(recipe: recipe)
            }
        }
        fetchRecipes()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView(dataSource: RecipeDataSourceManager(context: PersistenceController.preview.container.viewContext))
    }
}
