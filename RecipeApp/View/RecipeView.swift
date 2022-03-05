//
//  RecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct RecipeView: View {
    var recipe: LightRecipe
    
    init(recipe: LightRecipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        TopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipe.image, geometry: geometry)
                    } else {
                        OtherTopImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipe.name, geometry: geometry)
                    }
                }
            }
            .frame(height: 400)
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .bold().font(.title2)
                    .lineLimit(nil)
                    .padding(.top, 10)
                Text(recipe.description)

                    .lineLimit(nil)
                    .padding(.top, 30)
            }
            .frame(width: 350)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: LightRecipe(numRecipe: 239, name: "Saint Honoré", nbDiners: 10, image: "saint_honore-2.jpg", category: RecipeCategory(rawValue: 3)!, description: "Le saint-honoré est une pâtisserie française, à base de crème Chantilly, de crème chiboust et de petits choux glacés au sucre.", ingredientCost: 20.72, duration: 80))
    }
}
