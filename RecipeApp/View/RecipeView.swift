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
    private var viewArray = ["Etapes"/*, "Ingrédients", */,"Coûts"]
    
    init(recipe: LightRecipe) {
        self.recipeVM = RecipeVM(model: recipe, steps: [])
    }
    
    var body: some View {
        ScrollView {
            /*GeometryReader { geometry in
             ZStack {
             if geometry.frame(in: .global).minY <= 0 {
             TopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.image, geometry: geometry)
             } else {
             OtherTopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.name, geometry: geometry)
             }
             }
             }
             .frame(height: 400)*/
            StickyHeader{
                ImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.image)
            }.frame(height: 400)
            VStack(alignment: .leading) {
                Text(recipeVM.model.name)
                    .bold().font(.title2)
                    .padding(.top, 5)
                
                
                Text(recipeVM.model.description)
                    .padding(.top, 5)
                
                Section {
                    Picker(selection: $selectedIndex, label: EmptyView()) {
                        ForEach(0 ..< viewArray.count) {
                            Text(self.viewArray[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                //Text(viewArray[selectedIndex])
                
                
                
                //                ForEach(Array(recipeVM.steps.enumerated()), id:\.element.numStep){ index, step in
                //                    VStack(alignment: .leading){
                //                        Text(step.name + " (" + String(step.duration) + " min)")
                //                            .bold()
                //                        Text(step.description)
                //                        Divider()
                //
                //                    }
                //                }
                //                .padding(.top, 5)
                getViewSelected(selectedIndex: selectedIndex)
                
            }.padding(10).cornerRadius(10)
            
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            if recipeVM.steps.count == 0 {
                Task {
                    await recipeVM.getSteps(numRecipe: recipeVM.model.numRecipe!)
                    print(recipeVM.steps)
                    print(recipeVM.steps.count)
                }
            }
        }
    }
    
    @ViewBuilder
    private func getViewSelected(selectedIndex: Int) -> some View {
        if(selectedIndex == 0){
            RecipeStepsView(recipeVM: recipeVM)
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
                Text(step.name + " (" + String(step.duration) + " min)")
                    .bold()
                Text(step.description)
                Divider()
                
            }
        }
        .padding(.top, 5)
    }
}

struct RecipeCostsView : View {
    @ObservedObject var recipeVM: RecipeVM
    var columns: [GridItem] =
    [GridItem(.flexible()), GridItem(.fixed(80))]
    
    init(recipeVM: RecipeVM){
        self.recipeVM = recipeVM
        self.duration = recipeVM.model.duration!
        self.ingredientCost = Double(round(100*recipeVM.model.ingredientCost!)/100)
        self.flavoringCost =  Double(round(100*(ingredientCost*0.05))/100)
        self.productCost = Double(round(100*(ingredientCost + flavoringCost))/100)
        self.personnelCost = Double(round(100*(Double(duration) + averageMinuteRate))/100)
        self.fluidCost = Double(round(100*(Double(duration) + averageMinuteRateFluid))/100)
        self.chargesCost = Double(round(100*(personnelCost + fluidCost))/100)
        self.totalCost = Double(round(100*(chargesCost + productCost))/100)
    }
    
    let averageMinuteRate: Double = 0.175
    let averageMinuteRateFluid: Double = 0.0198
    var ingredientCost: Double
    var duration: Int
    
    var flavoringCost: Double
    var productCost: Double
    var personnelCost: Double
    var fluidCost: Double
    var chargesCost: Double
    var totalCost: Double
    
    var body : some View {
        LazyVGrid(columns: columns, alignment: .leading){
            Group{
                Group{
                    Text("Coût des matières").bold() ; Text(String(productCost)+"€").bold()
                    Text("  Coût des ingrédients") ; Text(String(ingredientCost)+"€")
                    Text("  Coût de l'assaisonnement (5%)") ; Text(String(flavoringCost) + "€")
                }
                Divider()
                Divider()
                Group{
                    Text("Coût des charges").bold() ; Text(String(chargesCost)+"€").bold()
                    Text("  Coût du personnel") ; Text(String(personnelCost)+"€")
                    Text("  Coût des fluides") ; Text(String(fluidCost)+"€")
                }
                Divider()
                Divider()
                Text("Total").bold() ; Text(String(totalCost)+"€").bold()
            }.padding(.leading, 5)
        }
        .padding(5)
        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
        .cornerRadius(5)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: LightRecipe(numRecipe: 239, name: "Saint Honoré", nbDiners: 10, image: "saint_honore-2.jpg", category: RecipeCategory(rawValue: 3)!, description: "Le saint-honoré est une pâtisserie française, à base de crème Chantilly, de crème chiboust et de petits choux glacés au sucre.", ingredientCost: 20.72, duration: 80))
    }
}
