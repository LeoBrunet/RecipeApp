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
    @State private var edit = false
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
    
    init(ingredient: Ingredient, ingredients: IngredientsVM){
        self.ingredients = ingredients
        self.ingredient = IngredientVM(model: ingredient)
    }
    
    var body: some View {
        VStack{
            LazyVGrid(columns: cols, alignment: .leading) {
                Group{
                    Text("Nom : ")
                    TextField("", text: $ingredient.nameIngredient).disabled(edit)
                        .onSubmit {
                            //self.intent.intentToChange(ingredientName: ingredient.nameIngredient)
                        }
                }
                
                Group{
                    Text("Type : ")
                    Picker("", selection: $ingredient.idType) {
                        ForEach(IngredientType.allCases, id: \.self) { value in
                            Text(value.name).tag(value)
                        }
                    }
                }
                
                Group{
                    Text("Allergène : ")
                    Picker("", selection: $ingredient.codeAllergen) {
                        ForEach(Allergen.allCases, id: \.self) { value in
                            Text(value.name).tag(value)
                        }
                    }
                }
                
                Group{
                    Text("Prix unitaire : ")
                    TextField("", value: $ingredient.unitePrice, formatter: numberF)
                }
                
                Group{
                    Text("Stock : ")
                    TextField("", value: $ingredient.stock, formatter: numberF)
                }
                
                Group{
                    Text("Unité : ")
                    Picker("", selection: $ingredient.idUnit) {
                        ForEach(IngredientUnit.allCases, id: \.self) { value in
                            Text(value.name).tag(value)
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
