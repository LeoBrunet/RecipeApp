//
//  RecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var recipeVM: RecipeVM
    @State private var selectedIndex = 0
    private var viewArray = ["Etapes", "Ingrédients", "Coûts", "Vendre"]
    
    init(recipe: LightRecipe) {
        self.recipeVM = RecipeVM(model: recipe, steps: [])
    }
    
    var body: some View {
        ScrollView {
            StickyHeader{
                ImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.image)
            }.frame(height: 400)
            VStack(alignment: .leading) {
                HStack{
                    Text(recipeVM.model.name)
                        .bold().font(.title2)
                        .padding(.top, 5)
                }
                
                Text(recipeVM.model.description)
                    .padding(.top, 5)
                
                Section {
                    Picker(selection: $selectedIndex, label: EmptyView()) {
                        ForEach(0 ..< viewArray.count) {
                            Text(self.viewArray[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                getViewSelected(selectedIndex: selectedIndex)
                
            }.padding(10).cornerRadius(10)
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            if recipeVM.steps.count == 0 {
                Task {
                    await recipeVM.getSteps(numRecipe: recipeVM.model.numRecipe!)
                }
            }
        }
    }
    
    @ViewBuilder
    private func getViewSelected(selectedIndex: Int) -> some View {
        if(selectedIndex == 0){
            RecipeStepsView(recipeVM: recipeVM)
        } else if (selectedIndex == 1){
            RecipeIngredientsView(recipeVM: recipeVM)
        } else if (selectedIndex == 3){
            RecipeSellView(recipeVM: recipeVM)
        } else {
            RecipeCostsView(recipeVM: recipeVM)
        }
    }
}

struct RecipeStepsView : View {
    
    @ObservedObject var recipeVM: RecipeVM
    
    init(recipeVM: RecipeVM){
        self.recipeVM = recipeVM
    }
    
    var body : some View {
        ForEach(Array(recipeVM.steps.enumerated()), id:\.element.numStep){ index, step in
            VStack(alignment: .leading){
                isRecipeStep(step: step)
                hasIngredients(nbIngredients: step.ingredients.count, step: step)
                Text(step.description)
            }
            Divider()
        }
        .padding(.top, 5)
    }
    
    @ViewBuilder
    private func hasIngredients(nbIngredients: Int, step: Step) -> some View {
        if(nbIngredients > 0){
            HasIngredients(step: step)
        } else {
            EmptyView()
        }
    }

    
    @ViewBuilder
    private func isRecipeStep(step: Step) -> some View {
        if(step.duration > 0){
            Text(step.name + " (" + String(step.duration) + " min)")
                .bold()
        } else {
            Text(step.name).bold()
        }
    }
}

struct HasIngredients : View {
    var step : Step
    
    init(step: Step){
        self.step = step
    }
    var body : some View {
        VStack(alignment: .leading){
            Text("Ingrédients").bold()
            ForEach(Array(step.ingredients.enumerated()), id:\.element.numIngredient){ index, ingredient in
                Text(String(ingredient.quantity!) + ingredient.idUnit.name + " " + ingredient.nameIngredient)
            }
        }
        .padding(10)
        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        .cornerRadius(5)
    }
}

struct RecipeIngredientsView : View {
    
    @ObservedObject var recipeVM: RecipeVM
    
    init(recipeVM: RecipeVM){
        self.recipeVM = recipeVM
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Ingrédients").bold()
            ForEach(Array(recipeVM.ingredients.enumerated()), id:\.element.numIngredient!){ index, ingredient in
                Text(String(ingredient.quantity!) + ingredient.idUnit.name + " " + ingredient.nameIngredient)
            }
        }
        .padding(10)
        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        .cornerRadius(5)
        .onAppear {
            if recipeVM.ingredients.count == 0 {
                Task {
                    await recipeVM.getIngredientsOfRecipe(recipeNum: recipeVM.model.numRecipe!)
                    print(recipeVM.ingredients.count)
                }
            }
        }
    }
}

struct RecipeCostsView : View {
    @ObservedObject var recipeVM: RecipeVM
    var columns: [GridItem] =
    [GridItem(.flexible()), GridItem(.fixed(80))]
    
    init(recipeVM: RecipeVM){
        self.recipeVM = recipeVM
    }
    
    var body : some View {
        LazyVGrid(columns: columns, alignment: .leading){
            Group{
                Group{
                    Text("Coût des matières").bold() ; Text(String(recipeVM.productCost)+"€").bold()
                    Text("  Coût des ingrédients") ; Text(String(recipeVM.ingredientCost!)+"€")
                    Text("  Coût de l'assaisonnement (5%)") ; Text(String(recipeVM.flavoringCost) + "€")
                }
                Divider()
                Divider()
                Group{
                    Text("Coût des charges").bold() ; Text(String(recipeVM.chargesCost)+"€").bold()
                    Text("  Coût du personnel") ; Text(String(recipeVM.personnelCost)+"€")
                    Text("  Coût des fluides") ; Text(String(recipeVM.fluidCost)+"€")
                }
                Divider()
                Divider()
                Text("Total").bold() ; Text(String(recipeVM.totalCost)+"€").bold()
            }.padding(.leading, 5)
        }
        .padding(5)
        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        .cornerRadius(5)
    }
}

struct RecipeSellView : View {
    
    @State var qte: Int = 1
    @State private var showingAlert = false
    
    var recipeVM: RecipeVM
    
    init(recipeVM: RecipeVM){
        self.recipeVM = recipeVM
    }
    
    var body: some View {
        HStack{
            Text("Quantité : " + String(qte))
            Stepper("Quantité", value: $qte, in: 1...99)
                .labelsHidden()
            Spacer()
            Button {
                print("vend " + String(qte))
                Task{
                    let _ = await recipeVM.sell(sale: Sale(numSale: 0, quantity: qte, date: Date.now, numRecipe: recipeVM.model.numRecipe!, nameRecipe: recipeVM.model.name, cost: recipeVM.totalCost, price: recipeVM.price))
                    showingAlert = true
                }
            } label: {
                VStack(alignment:.leading){
                    Text("Vendre")
                        .cornerRadius(5)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color("Green"))
                    
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Opération validée"),
                          message: Text("Vérifiez dans l'onglet vente, la vente suivante : " + String(qte) + " " + recipeVM.name + "."),
                          dismissButton: .default(Text("D'accord"))
                    )
                }
            }
            
            
        }.padding(5)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: LightRecipe(numRecipe: 239, name: "Saint Honoré", nbDiners: 10, image: "saint_honore-2.jpg", category: RecipeCategory(rawValue: 3)!, description: "Le saint-honoré est une pâtisserie française, à base de crème Chantilly, de crème chiboust et de petits choux glacés au sucre.", ingredientCost: 20.72, duration: 80))
    }
}
