//
//  RecipeDTO.swift
//  RecipeApp
//
//  Created by Leo Brunet on 28/02/2022.
//

import Foundation

struct LightRecipeDTO: Codable {
    var numRecipe: Int?
    var numUser: Int? = 1
    var name: String
    var nbDiners: Int
    var image: String
    var idCategory: RecipeCategory
    var description: String
    var ingredientCost: Double?
    var duration: Int?
}
