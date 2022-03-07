//
//  StepPostDTO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 07/03/2022.
//

import Foundation

struct StepPostDTO : Codable{
    var position: Int
    var recipeStep: Int?
    var proprietaryRecipe: Int
    var nameStep: String?
    var description: String?
    var duration: Int?
    var ingredients: [IngredientPostDTO]?
}
