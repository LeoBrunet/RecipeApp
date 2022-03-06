//
//  LightRecipeVM.swift
//  RecipeApp
//
//  Created by Leo Brunet on 28/02/2022.
//

import Foundation
import Combine

class LightRecipesVM : ObservableObject, Subscriber {
    
    @Published var recipes : [LightRecipe] = []
    
    func getAllRecipes() async {
        let request : Result<[LightRecipe], Error> = await LightRecipeDAO.getRecipes()
        
        switch(request){
            
        case .success(let recipes):
            self.recipes = recipes
            
        case .failure(let error):
            print(error)
        }
        
    }
    
    typealias Input = RecipeListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
       subscription.request(.unlimited) // unlimited : on veut recevoir toutes les valeurs
    }
    // au cas où le publisher déclare qu'il finit d'émetter : nous concerne pas
    func receive(completion: Subscribers.Completion<Never>) {
       return
    }

     // Activée à chaque send() du publisher :
    func receive(_ input: RecipeListIntentState) -> Subscribers.Demand {
       print("vm -> intent \(input)")
       switch input{
          case .ready:
             break
       case .listUpdated:
           self.objectWillChange.send()
       case .newElement(let rec):
           self.recipes.append(rec)
           self.objectWillChange.send()
       }
       return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
    
}
