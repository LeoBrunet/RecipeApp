//
//  LightRecipeVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import Foundation
import Combine

class RecipeVM: ObservableObject, Subscriber {
    
    var model : LightRecipe
    var steps : [Step]
    var numRecipe: Int?
    @Published var name: String
    @Published var nbDiners: Int
    @Published var image: String
    @Published var category: RecipeCategory
    @Published var description: String
    var ingredientCost: Double?
    var duration: Int?
    
    init(model: LightRecipe, steps: [Step]) {
        self.model = model
        self.numRecipe = model.numRecipe
        self.name = model.name
        self.nbDiners = model.nbDiners
        self.image = model.image
        self.category = model.category
        self.description = model.description
        self.ingredientCost = model.ingredientCost
        self.duration = model.duration
        self.steps = steps
    }
    
    typealias Input = RecipeIntentState
    typealias Failure = Never
    
    func getSteps(numRecipe: Int) async {
        let request : Result<[Step], Error> = await StepDAO.getSteps(numRecipe: numRecipe)
        
        switch(request){

        case .success(let steps):
            self.steps = steps

        case .failure(let error):
            print(error)
        }
    }
    
    // appelée à l'inscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited) // unlimited : on veut recevoir toutes les valeurs
    }
    // au cas où le publisher déclare qu'il finit d'émetter : nous concerne pas
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    // Activée à chaque send() du publisher :
    func receive(_ input: RecipeIntentState) -> Subscribers.Demand {
        print("vm -> intent \(input)")
        switch input{
        case .ready:
            break
        case .recipeAdding:
            self.numRecipe = self.model.numRecipe
            self.name = self.model.name
            self.nbDiners = self.model.nbDiners
            self.image = self.model.image
            self.category = self.model.category
            self.description = self.model.description
            self.ingredientCost = self.model.ingredientCost
            self.duration = self.model.duration
        }

        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
