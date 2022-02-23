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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init(index: Int, ingredients : IngredientsVM){
        self.index = index
        self.ingredients = ingredients
        self.ingredient = IngredientVM(model: ingredients.ingredients[index])
    }
}

//struct IngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}
