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
    @State var isCategorySheetShown: Bool = false
    @State var isAddSheetShown: Bool = false
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
                Group{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Catégories"){
                            isCategorySheetShown = true
                        }
                        .sheet(isPresented: $isCategorySheetShown){
                            CategoryView(selection: $selection)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            isAddSheetShown = true
                        } label : {
                            Label("", systemImage: "plus")
                        }
                        .sheet(isPresented: $isAddSheetShown){
                            AddIngredientView(ingredients: ingredientsVM)
                        }
                    }
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
    @State var buttonText = "Tout déselectionner"
    
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
                Button(buttonText, action: {
                    if(IngredientType.allCases.allSatisfy(selection.contains)){
                        selection = Set()
                        buttonText = "Tout sélectionner"
                    }else{
                        selection = Set(IngredientType.allCases)
                        buttonText = "Tout désélectionner "
                    }
                    
                }).onChange(of: selection){ newValue in
                    if(IngredientType.allCases.allSatisfy(selection.contains)){
                        buttonText = "Tout désélectionner"
                    }else{
                        buttonText = "Tout sélectionner "
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("Catégories")
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
