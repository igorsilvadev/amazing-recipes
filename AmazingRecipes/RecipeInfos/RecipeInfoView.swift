//
//  RecipeInfoView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 31/05/23.
//

import SwiftUI

struct RecipeInfoView: View {
    // Experimente remover o StateObject do recipe. Você notará que ao voltar da tela de edição, mesmo salvando os valores não mudarão. 
    @StateObject var recipe: Recipe
    @State private var showEditView = false
    var body: some View {
        ScrollView {
            VStack {
                // MARK: Image
                if let data = recipe.image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(recipe.title ?? "")
                        .font(.title)
                        .padding(.leading)
                    CustomTextInfo(title: "Custo de preparo:", text: "R$\(recipe.price.formatted())")
                    CustomTextInfo(title: "Tempo de preparo:", text: "\(recipe.preparationTime) minutos")
                    CustomTextInfo(title: "Modo de preparo:", text: recipe.desc ?? "")
                    Text("Ingredientes:")
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    // MARK: Listagem dos ingredientes
                    // Note que é feito um cast do tipo de dados. Essa conversão é necessária porque os dados são armazenados como Any, porém caso não seja informado o tipo correto ocorrerá um erro de casting.
                    ForEach(recipe.ingredients?.allObjects as? [Ingredient] ?? []) { ingredient in
                        Text(ingredient.name ?? "")
                            .padding(.leading)
                    }
                    
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $showEditView, content: {
                EditRecipeView(recipe: recipe)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Editar") {
                        showEditView = true
                    }
                }
            }
        }
    }
}

struct CustomTextInfo: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .fontWeight(.bold)
            
            Text(text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}

struct RecipeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeInfoView(recipe: try! PersistenceController.preview.container.viewContext.fetch(Recipe.fetchRequest()).first!)
    }
}

