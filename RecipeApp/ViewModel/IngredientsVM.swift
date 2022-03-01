//
//  IngredientsVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation
import Combine

class IngredientsVM : ObservableObject, Subscriber {
    
    @Published var ingredients : [Ingredient] = []
    
    func getAllIngredients() async {
        let request : Result<[Ingredient], Error> = await IngredientDAO.getIngredients()
        
        switch(request){

        case .success(let ingredients):
            self.ingredients = ingredients

        case .failure(let error):
            print(error)
        }
    }
    
    func receive(subscription: Subscription) {
       subscription.request(.unlimited) // unlimited : on veut recevoir toutes les valeurs
    }
    // au cas où le publisher déclare qu'il finit d'émetter : nous concerne pas
    func receive(completion: Subscribers.Completion<Never>) {
       return
    }

     // Activée à chaque send() du publisher :
    func receive(_ input: IngredientListIntentState) -> Subscribers.Demand {
       print("vm -> intent \(input)")
       switch input{
          case .ready:
             break
       case .listUpdated:
           self.objectWillChange.send()
       }
       return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
    
    typealias Input = IngredientListIntentState
    typealias Failure = Never
}

