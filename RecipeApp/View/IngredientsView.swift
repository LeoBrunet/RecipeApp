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
    @State private var showingSheet = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var selection:Set<IngredientType> = Set(IngredientType.allCases)

    
    var body: some View {
        NavigationView{
            VStack{
                
                
                List {
                    ForEach(sectionDictionary.keys.sorted(), id:\.self) { key in
                        if let ingredients = sectionDictionary[key]{
                            Section(header: Text("\(key)")) {
                                ForEach(Array(ingredients.enumerated()), id:\.element.numIngredient){ index, ing in
                                    NavigationLink(destination: IngredientView(ingredient: ing, ingredients: ingredientsVM)){
                                        HStack(){
                                            if(colorScheme == .light){
                                                Label(title: {
                                                    Text(ing.nameIngredient).font(.system(size: 16, weight: .semibold, design: .rounded))
                                                }, icon: {
                                                    Image(ing.idType.icon).resizable().scaledToFit().frame(width: 30).colorMultiply(.black)
                                                    
                                                })
                                            }
                                            else{
                                                Label(title: {
                                                    Text(ing.nameIngredient).font(.system(size: 16, weight: .semibold, design: .rounded))
                                                }, icon: {
                                                    Image(ing.idType.icon).resizable().scaledToFit().frame(width: 30)
                                                })
                                            }
                                            Spacer()
                                            Text(String(ing.stock) + ing.idUnit.name)
                                        }
                                    }
                                }
                            }.headerProminence(.increased)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
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
                    Button("Catégories"){
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        CategoryView(selection: $selection)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "plus").foregroundColor(Color("Green"))
                }
            }
            
        }.tint(Color("Green"))
        
    }
    
    var sectionDictionary : Dictionary<String , [Ingredient]> {
        if searchText.isEmpty {
            return Ingredient.getSectionedDictionary(ingredients: ingredientsVM.ingredients.filter({selection.contains($0.idType)}))
        } else {
            return Ingredient.getSectionedDictionary(ingredients: ingredientsVM.ingredients.filter({$0.nameIngredient.contains(searchText) && selection.contains($0.idType)}))
        }
    }
}

struct CategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var editMode = EditMode.active
    @Binding var selection:Set<IngredientType>
    
    let types = IngredientType.allCases
    
    var body: some View {
        NavigationView {
            VStack(){
                List(types, id: \.self, selection: $selection) { type in
                    if(colorScheme == .light){
                        Label(title: {
                            Text(type.name).font(.system(size: 16, weight: .semibold, design: .rounded))
                        }, icon: {
                            Image(type.icon).resizable().scaledToFit().frame(width: 30).colorMultiply(.black)
                            
                        })
                    }
                }
                .onAppear(){
                  UITableView.appearance().backgroundColor = UIColor.clear
                  UITableViewCell.appearance().backgroundColor = UIColor.clear
                    
                }
                Button("Tout sélectionner", action: {
                    selection = Set(IngredientType.allCases)
                })
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("Catégorie")
            .toolbar{
                Button("Ok") {
                    dismiss()
                }
            }
        }
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
