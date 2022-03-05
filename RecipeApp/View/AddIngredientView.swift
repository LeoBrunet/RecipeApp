//
//  AddIngredientView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 04/03/2022.
//

import SwiftUI

struct AddIngredientView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var ingredients: IngredientsVM
    @ObservedObject var ingredient: IngredientVM = IngredientVM(model: Ingredient(numIngredient: nil, nameIngredient: "", unitePrice: 0, codeAllergen: Allergen.Aucun, idType: IngredientType.Autre, idUnit: IngredientUnit.kg, stock: 0))
    var ingredientIntent : IngredientIntent
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init( ingredients: IngredientsVM){
        self.ingredients = ingredients
        self.ingredientIntent = IngredientIntent()
        
        self.ingredientIntent.addObserver(viewModel: self.ingredient, listViewModel: self.ingredients)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading) {
                    Group{
                        Text("Nom").font(.headline)
                        TextField("", text: $ingredient.nameIngredient)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                    }
                    
                    Group{
                        Text("Prix unitaire").font(.headline)
                        HStack{
                            TextField("", value: $ingredient.unitePrice, formatter: numberF)
                                .padding(5)
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .cornerRadius(5)
                            Text("€")
                        }
                        
                    }
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("Stock").font(.headline)
                            TextField("", value: $ingredient.stock, formatter: numberF)
                                .padding(5)
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .cornerRadius(5)
                        }
                        Spacer()
                        VStack(alignment: .leading){
                            Text("Unité").font(.headline)
                            Picker("", selection: $ingredient.idUnit) {
                                ForEach(IngredientUnit.allCases, id: \.self) { value in
                                    Text(value.name).tag(value)
                                }
                            }
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                        }
                    }
                    
                    HStack(spacing: 30){
                        VStack(alignment: .leading){
                            Text("Type").font(.headline)
                            Picker("", selection: $ingredient.idType) {
                                ForEach(IngredientType.allCases, id: \.self) { value in
                                    Text(value.name).tag(value)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Allergène").font(.headline)
                            Picker("", selection: $ingredient.codeAllergen) {
                                ForEach(Allergen.allCases, id: \.self) { value in
                                    Text(value.name).tag(value)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                        }
                    }
                    
                    
                }.padding()
                Button("Ajouter"){
                    Task{
                        await self.ingredientIntent.intentToAdd(ingredient: ingredient.model)
                        dismiss()
                    }
                }
                .padding()
                .disabled(ingredient.nameIngredient.isEmpty)
                Spacer()
            }
            .navigationTitle("Ajouter un ingrédient")
            .toolbar{
                Button("Annuler") {
                    dismiss()
                }
            }
        }
        
    }
}
