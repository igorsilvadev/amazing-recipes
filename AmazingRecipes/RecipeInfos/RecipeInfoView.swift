//
//  RecipeInfoView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 31/05/23.
//

import SwiftUI

struct RecipeInfoView: View {
    var recipe: Recipe
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10){
                    Text(recipe.title ?? "")
                        .font(.title)
                        .padding(.leading)
                    CustomTextInfo(title: "Custo de preparo:", text: "R$\(recipe.price.formatted())")
                    CustomTextInfo(title: "Tempo de preparo:", text: "\(recipe.preparationTime) minutos")
                    CustomTextInfo(title: "Modo de preparo:", text: recipe.desc ?? "")
                    
                }
                Spacer()
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

