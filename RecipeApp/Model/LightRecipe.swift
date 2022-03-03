//
//  Recipe.swift
//  RecipeApp
//
//  Created by Leo Brunet on 28/02/2022.
//

import Foundation

class LightRecipe {
    var numRecipe: Int
    var name: String
    var nbDiners: Int
    var image: String
    var category: RecipeCategory
    var description: String
    var ingredientCost: Double
    var duration: Int
    
    init(numRecipe: Int, name: String, nbDiners: Int, image: String, category: RecipeCategory, description: String, ingredientCost: Double, duration: Int) {
        self.numRecipe = numRecipe
        self.name = name
        self.nbDiners = nbDiners
        self.image = image
        self.category = category
        self.description = description
        self.ingredientCost = ingredientCost
        self.duration = duration
    }
}
