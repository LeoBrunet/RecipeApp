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
    var RecipeStep: LightRecipeDTO?
    var descriptionStep: DescriptionStepDTO?
    
    /*struct RecipeStep : Codable {
        let lightRecipeDTO: LightRecipeDTO?
        
        init(from decoder: Decoder) throws {
            let container =  try decoder.singleValueContainer()
            
            // Check for a light recipe
            do {
                lightRecipeDTO = try container.decode(LightRecipeDTO.self)
            } catch {
                // Check for an integer
                lightRecipeDTO = nil
            }
        }
        
        // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try lightRecipeDTO != nil ? container.encode(lightRecipeDTO) : container.encodeNil()
        }
    }
    
    struct DescriptionStep : Codable {
        let descriptionStepDTO: DescriptionStepDTO?
        
        init(from decoder: Decoder) throws {
            let container =  try decoder.singleValueContainer()
            
            // Check for a boolean
            do {
                descriptionStepDTO = try container.decode(DescriptionStepDTO.self)
            } catch {
                // Check for an integer
                descriptionStepDTO = nil
            }
        }
        
        // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try descriptionStepDTO != nil ? container.encode(descriptionStepDTO) : container.encodeNil()
        }
    }*/
    
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
