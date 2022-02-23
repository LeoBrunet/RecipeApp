//
//  IngredientsView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct IngredientsView: View {
    @StateObject var ingredientsVM: IngredientsVM = IngredientsVM()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(Array(searchResults.enumerated()), id:\.element.numIngredient){ index, ing in
                        NavigationLink(destination: IngredientView(index: index, ingredients: ingredientsVM)){
                            VStack(alignment: .leading){
                                Text(ing.nameIngredient)
                                Text(String(ing.stock))
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .onAppear(){
                    if ingredientsVM.ingredients.count == 0{
                        Task{
                            await ingredientsVM.getAllIngredients()
                        }
                    }
                }
            }
            .navigationTitle("Ingrédients")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {},label: {Text("Catégories")})
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "plus").foregroundColor(Color("Green"))
                }
            }
            
        }.tint(Color("Green"))
        
    }
    
    var searchResults: [Ingredient] {
        if searchText.isEmpty {
            return ingredientsVM.ingredients
        } else {
            return ingredientsVM.ingredients.filter({$0.nameIngredient.contains(searchText)})
        }
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
