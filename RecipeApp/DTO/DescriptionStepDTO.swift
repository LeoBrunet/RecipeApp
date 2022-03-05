//
//  DescriptionStepDTO.swift
//  RecipeApp
//
//  Created by Leo Brunet on 05/03/2022.
//

import Foundation

struct DescriptionStepDTO : Codable {
    var nameStep: String
    var description: String
    var duration: Int
    var ingredients: [IngredientDTO]
}
