//
//  StepDTO.swift
//  RecipeApp
//
//  Created by Leo Brunet on 05/03/2022.
//

import Foundation

struct StepDTO : Codable{
    var numStep: Int
    var position: String
    var recipeStep: LightRecipeDTO?
    var descriptionStep: DescriptionStepDTO?
    
    /*enum CodingKeys: String, CodingKey {
        case numStep = "numStep"
        case position = "position"
        case recipeStep = "recipeStep"
        case descriptionStep = "descriptionStep"
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        recipeStep = try values.decodeIfPresent(LightRecipeDTO.self, forKey: .recipeStep)
        numStep = try values.decode(Int.self, forKey: .numStep)
        position = try values.decode(String.self, forKey: .position)
        descriptionStep = try values.decodeIfPresent(DescriptionStepDTO.self, forKey: .descriptionStep)
    }*/
}
