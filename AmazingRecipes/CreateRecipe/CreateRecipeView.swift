//
//  CreateRecipeView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 30/05/23.
//

import SwiftUI
import CoreData

struct CreateRecipeView: View {
    
    @State private var title = ""
    @State private var price = 0.0
    @State private var preparationTime = 0
    @State private var image: Data?
    @State private var desc = ""
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var priceFormmater: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20){
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
                
                // MARK: DESCRIÇÃO DE PREPARO
                VStack(alignment: .leading) {
                    Text("Modo de preparo:")
                    TextEditor(text: $desc)
                        .border(.gray.opacity(0.3))
                        .frame(height: 150)
                }
                
                
            }
            .padding()
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
        }
    }
    
    func saveRecipe() {
        let recipe = Recipe(context: viewContext)
        recipe.title = title
        recipe.price = price
        recipe.desc = desc
        recipe.image = image
        recipe.preparationTime = Int16(preparationTime)
        recipe.timestamp = Date()
        try? viewContext.save()
        dismiss()
    }
    
    func canSave() -> Bool {
        return !title.isEmpty
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}
