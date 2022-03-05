//
//  Step.swift
//  RecipeApp
//
//  Created by Leo Brunet on 03/03/2022.
//

import Foundation

class Step {
    var numStep: Int
    var name: String
    var description: String
    var ingredients: [Ingredient]
    var duration: Int
    
    init(numStep: Int, name: String, description: String, ingredients: [Ingredient], duration: Int) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.numStep = numStep
    }
}
