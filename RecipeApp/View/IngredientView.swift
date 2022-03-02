//
//  IngredientView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI



struct IngredientView: View {
    @ObservedObject var ingredients: IngredientsVM
    @ObservedObject var ingredient: IngredientVM
    var ingredientIntent : IngredientIntent
    
    var cols = [
        GridItem(.fixed(200)),
        GridItem(.flexible())
    ]
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(ingredient: Ingredient, ingredients: IngredientsVM){
        self.ingredients = ingredients
        self.ingredient = IngredientVM(model: ingredient)
        self.ingredientIntent = IngredientIntent()
        
        self.ingredientIntent.addObserver(viewModel: self.ingredient, listViewModel: self.ingredients)
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Group{
                    Text("Nom").font(.headline)
                    TextField("", text: $ingredient.nameIngredient)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                        .onSubmit{
                            self.ingredientIntent.intentToChange(ingredientName: ingredient.nameIngredient)
                        }
                }
                
                Group{
                    Text("Prix unitaire").font(.headline)
                    HStack{
                        TextField("", value: $ingredient.unitePrice, formatter: numberF)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                            .onSubmit {
                                self.ingredientIntent.intentToChange(unitePrice: ingredient.unitePrice)
                            }
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
                            .onSubmit{
                                self.ingredientIntent.intentToChange(stock: ingredient.stock)
                            }
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
                        .onDisappear{
                            self.ingredientIntent.intentToChange(unit: ingredient.idUnit)
                        }
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
                        .onDisappear{
                            self.ingredientIntent.intentToChange(type: ingredient.idType)
                        }
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
                        .onDisappear{
                            self.ingredientIntent.intentToChange(allergen: ingredient.codeAllergen!)
                        }
                    }
                }
                
                
            }.padding()
            Spacer()
        }
        .navigationTitle(self.ingredient.nameIngredient)
        .toolbar{
            ToolbarItem(placement: .principal){
                Image(ingredient.idType.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30, alignment: .center).colorMultiply(Color("Green"))
            }
        }
    }
}




//struct IngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}
