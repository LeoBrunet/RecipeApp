//
//  GeneralStep.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 06/03/2022.
//

import Foundation

enum GeneralStep: Hashable {
    func hash(into hasher: inout Hasher) {

            switch self {
            case .recipe(let value):
                hasher.combine(value) // combine with associated value, if it's not `Hashable` map it to some `Hashable` type and then combine result
            case .description(let value):
                hasher.combine(value) // combine with associated value, if it's not `Hashable` map it to some `Hashable` type and then combine result
            }
        }
    
    case recipe(LightRecipe)
    case description(Step)
}
