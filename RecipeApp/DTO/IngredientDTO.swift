//
//  IngredientsDTO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

struct IngredientDTO: Codable{
    var numIngredient: Int?
    var nameIngredient: String
    var unitePrice: Double
    var codeAllergen: Allergen?
    var idType: IngredientType
    var idUnit: IngredientUnit
    var stock: Double
}
