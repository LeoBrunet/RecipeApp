//
//  IngredientView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI



struct IngredientView: View {
    var index: Int
    @ObservedObject var ingredients: IngredientsVM
    @ObservedObject var ingredient: IngredientVM
    //var intent: Intent
    
    var cols = [
        GridItem(.fixed(200)),
        GridItem(.flexible())
    ]
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(index: Int, ingredients: IngredientsVM){
        self.index = index
        self.ingredients = ingredients
        self.ingredient = IngredientVM(model: ingredients.ingredients[index])
    }
    
    var body: some View {
        VStack{
            LazyVGrid(columns: cols, alignment: .leading) {
                Group{
                    Text("Nom : ");
                    TextField("", text: $ingredient.nameIngredient)
                        .onSubmit {
                            //self.intent.intentToChange(ingredientName: ingredient.nameIngredient)
                        }
                }
            }.padding()
            Spacer()
        }
        .navigationTitle(self.ingredient.nameIngredient)
    }
}




//struct IngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}
