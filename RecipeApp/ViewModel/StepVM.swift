//
//  StepVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 06/03/2022.
//

import Foundation

class StepVM{
    var model: Step
    var numStep: Int?
    var name: String
    var description: String
    var ingredients: [Ingredient]
    var duration: Int
    
    init(model: Step) {
        self.model = model
        self.name = model.name
        self.description = model.description
        self.ingredients = model.ingredients
        self.duration = model.duration
        self.numStep = model.numStep
    }
}
