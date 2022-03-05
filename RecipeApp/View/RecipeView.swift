//
//  RecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct RecipeView: View {
    var recipeVM: RecipeVM
    
    init(recipe: LightRecipe) {
        self.recipeVM = RecipeVM(model: recipe, steps: [])
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        TopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.image, geometry: geometry)
                    } else {
                        OtherTopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipeVM.model.name, geometry: geometry)
                    }
                }
            }
            .frame(height: 400)
            VStack(alignment: .leading) {
                Text(recipeVM.model.name)
                    .bold().font(.title2)
                    .lineLimit(nil)
                    .padding(.top, 10)
                Text(recipeVM.model.description)

                    .lineLimit(nil)
                    .padding(.top, 30)
                List {
                    ForEach(Array(recipeVM.steps.enumerated()), id:\.element.numStep){ index, step in
                        Text(step.name)
                    }
                }
            }
            .frame(width: 350)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear{
            if recipeVM.steps.count == 0 {
                Task {
                    await recipeVM.getSteps(numRecipe: recipeVM.model.numRecipe!)
                }
            }
        }
    }
    
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: LightRecipe(numRecipe: 239, name: "Saint Honoré", nbDiners: 10, image: "saint_honore-2.jpg", category: RecipeCategory(rawValue: 3)!, description: "Le saint-honoré est une pâtisserie française, à base de crème Chantilly, de crème chiboust et de petits choux glacés au sucre.", ingredientCost: 20.72, duration: 80))
    }
}
