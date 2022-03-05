//
//  Recipe.swift
//  RecipeApp
//
//  Created by Leo Brunet on 03/03/2022.
//

import Foundation

class Recipe {
    var lightRecipe: LightRecipe
    var steps: [Step]
    
    init(lightRecipe: LightRecipe, steps: [Step]) {
        self.lightRecipe = lightRecipe
        self.steps = steps
    }
}
