//
//  EditRecipeView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 01/06/23.
//

import SwiftUI

struct EditRecipeView: View {
    
    @State private var title = ""
    @State private var price = 0.0
    @State private var preparationTime = 0
    @State private var image: Data?
    @State private var desc = ""
    
    @State private var presentAlert = false
    @State private var ingredientName = ""
    
    @State private var ingredients: [String] = []
    @Environment(\.dismiss) var dismiss
    
    // Aqui ocorre o acesso ao context do core data
    @Environment(\.managedObjectContext) private var viewContext
    
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    private var priceFormmater: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20){
                    
                    // MARK: Image Picker
                    ImagePickerView(selectedImageData: $image)
                    
                    // MARK: Titulo
                    VStack(alignment: .leading) {
                        Text("Titulo da receita:")
                        TextField("Titulo da receita", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // MARK: TEMPO DE PREPARO
                    VStack(alignment: .leading) {
                        Text("Tempo de preparo em minutos:")
                        TextField("Tempo de preparo em minutos", value: $preparationTime, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                    
                    // MARK: CUSTO DE PREPARO
                    VStack(alignment: .leading) {
                        Text("Custo de preparo:")
                        TextField("Custo de preparo", value: $price, formatter: priceFormmater)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                    // MARK: LISTAGEM DE INGREDIENTES
                    if !ingredients.isEmpty {
                        List {
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                                    .listRowBackground(Color.gray.opacity(0.3))
                            }
                            .onDelete(perform: deleteIngredients)
                        }
                        .background(.white)
                        .scrollContentBackground(.hidden)
                        .frame(height: 200)
                    }
                    
                    // MARK: Adicionar ingrediente
                    HStack {
                        Button {
                            presentAlert = true
                        } label: {
                            Label("Adicionar ingrediente", systemImage: "plus")
                        }
                        Spacer()
                    }
                    
                    
                    
                    // MARK: DESCRIÇÃO DE PREPARO
                    VStack(alignment: .leading) {
                        Text("Modo de preparo:")
                        TextEditor(text: $desc)
                            .border(.gray.opacity(0.3))
                            .frame(height: 150)
                    }
                    
                    
                }
                .padding()
                .alert("Ingrediente", isPresented: $presentAlert, actions: {
                    TextField("Nome", text: $ingredientName)
                    Button("Cancelar", role: .cancel) {
                        
                    }
                    Button("Adicionar") {
                        if !ingredientName.isEmpty {
                            ingredients.append(ingredientName)
                        }
                    }
                    
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancelar") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") {
                            saveRecipe()
                        }
                        .disabled(!canSave())
                    }
                }
                .onAppear {
                    setRecipeInfos()
                }
            }
        }
    }
    
    private func setRecipeInfos() {
        self.title = recipe.title ?? ""
        self.price = recipe.price
        self.preparationTime = Int(recipe.preparationTime)
        self.image = recipe.image
        self.desc = recipe.desc ?? ""
        self.ingredients = (recipe.ingredients?.allObjects as? [Ingredient] ?? []).map{ $0.name ?? ""}
    }
    
    private func saveRecipe() {
        recipe.title = title
        recipe.price = price
        recipe.desc = desc
        recipe.image = image
        recipe.preparationTime = Int16(preparationTime)
        recipe.timestamp = Date()
        

        // Primeiro deletar todos os ingredientes da receita
        (recipe.ingredients?.allObjects as? [Ingredient] ?? [])
            .forEach { ingredient in
                viewContext.delete(ingredient)
            }
        
        // Em seguida recriar a lista dos ingredientes que foram adicionados 
        ingredients.forEach { ingredientName in
            let ingredient = Ingredient(context: viewContext)
            ingredient.name = ingredientName
            recipe.addToIngredients(ingredient)
        }
        
        
        // Essa é uma segunda maneira de você salvar os dados sem precisar criar um block 'try catch'
        try? viewContext.save()
        dismiss()
    }
    
   private func canSave() -> Bool {
        return !title.isEmpty
    }
    
    private func deleteIngredients(offsets: IndexSet) {
        withAnimation {
            ingredients.remove(atOffsets: offsets)
        }
    }
}

struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRecipeView(recipe: try! PersistenceController.preview.container.viewContext.fetch(Recipe.fetchRequest()).first!)
        
    }
}
