//
//  Step.swift
//  RecipeApp
//
//  Created by Leo Brunet on 03/03/2022.
//

import Foundation

class Step {
    var name: String
    var description: String
    var ingredients: [Ingredient]
    var quantities: [Double]
    var duration: Int
    
    init(name: String, description: String, ingredients: [Ingredient], quantities: [Double], duration: Int) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.quantities = quantities
        self.duration = duration
    }
}
