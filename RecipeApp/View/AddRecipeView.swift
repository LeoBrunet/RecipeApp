//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import SwiftUI

struct AddRecipeView: View {
    @ObservedObject var recipes: LightRecipesVM
    @ObservedObject var recipe: LightRecipeVM
    //var recipeIntent : IngredientIntent
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(recipes: LightRecipesVM){
        self.recipes = recipes
        self.recipe = LightRecipeVM(model: LightRecipe(numRecipe: nil, name: "", nbDiners: 1, image: "", category: RecipeCategory.Entree, description: "", ingredientCost: nil, duration: nil))
        //self.ingredientIntent = IngredientIntent()
        
        //self.ingredientIntent.addObserver(viewModel: self.ingredient, listViewModel: self.ingredients)
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Group{
                    Text("Nom").font(.headline)
                    TextField("", text: $recipe.name)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                }
                
                Group{
                    Text("Description").font(.headline)
                    TextEditor(text: $recipe.description)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                }
                
                Group{
                    Text("Couverts").font(.headline)
                    HStack{
                        TextField("", value: $recipe.nbDiners, formatter: numberF)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                        Label("", systemImage: "fork.knife")
                    }
                    
                }
                
                VStack(alignment: .leading){
                    Text("Catégorie").font(.headline)
                    Picker("", selection: $recipe.category) {
                        ForEach(RecipeCategory.allCases, id: \.self) { value in
                            Text(value.name).tag(value)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    .cornerRadius(5)
                }
 
                
                
            }.padding()
            Button("Ajouter"){
//                Task{
//                    await self.ingredientIntent.intentToAdd(ingredient: ingredient.model)
//                    dismiss()
//                }
            }
            .padding()
            .disabled(recipe.name.isEmpty)
            Spacer()
        }
        .navigationTitle("Ajouter une recette")
    }
}
