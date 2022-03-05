//
//  LightRecipeVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import Foundation
import Combine

class LightRecipeVM: ObservableObject, Subscriber {
    
    var model : LightRecipe
    var numRecipe: Int?
    var name: String
    var nbDiners: Int
    var image: String
    var category: RecipeCategory
    var description: String
    var ingredientCost: Double?
    var duration: Int?
    
    init(model: LightRecipe) {
        self.model = model
        self.numRecipe = model.numRecipe
        self.name = model.name
        self.nbDiners = model.nbDiners
        self.image = model.image
        self.category = model.category
        self.description = model.description
        self.ingredientCost = model.ingredientCost
        self.duration = model.duration
    }
    
    typealias Input = IngredientIntentState
    typealias Failure = Never
    
    // appelée à l'inscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited) // unlimited : on veut recevoir toutes les valeurs
    }
    // au cas où le publisher déclare qu'il finit d'émetter : nous concerne pas
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    // Activée à chaque send() du publisher :
    func receive(_ input: IngredientIntentState) -> Subscribers.Demand {
        print("vm -> intent \(input)")
       
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
