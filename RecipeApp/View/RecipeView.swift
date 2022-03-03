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
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                StickyHeader {
                    StickyHeader {
                        ImageView(url:"https://nicolas-ig.alwaysdata.net/api/file/"+recipe.image)
                    }
                }
               
                VStack(alignment:.leading){
                    Text(recipe.name).bold().font(.title2)
                    Text(recipe.description)
                }
                
                // Scroll View Content Here
                // ...
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: LightRecipe(numRecipe: 239, name: "Saint Honoré", nbDiners: 10, image: "saint_honore-2.jpg", category: RecipeCategory(rawValue: 3)!, description: "Le saint-honoré est une pâtisserie française, à base de crème Chantilly, de crème chiboust et de petits choux glacés au sucre.", ingredientCost: 20.72, duration: 80))
    }
}
