//
//  Step.swift
//  RecipeApp
//
//  Created by Leo Brunet on 03/03/2022.
//

import Foundation

class Step: Hashable, ObservableObject {
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.numStep == rhs.numStep && lhs.isRecipe == rhs.isRecipe && lhs.name == lhs.name && lhs.description == lhs.description
    }
    
    
    func hash(into hasher: inout Hasher) {
        if(isRecipe){
            if(numStep != nil){
                hasher.combine(Double(numStep!) + 0.1)
            }
            else{
                hasher.combine(name+description)
            }
            
        }
        else{
            if(numStep != nil){
                hasher.combine(Double(numStep!) + 0.1)
            }
            else{
                hasher.combine(name+description)
            }
        }
        
    }
    
    var numStep: Int?
    var name: String
    var description: String
    @Published var ingredients: [Ingredient]
    var duration: Int
    var isRecipe: Bool
    
    init(numStep: Int?, name: String, description: String, ingredients: [Ingredient], duration: Int?, isRecipe: Bool) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration ?? 0
        self.numStep = numStep
        self.isRecipe = isRecipe
    }
}
