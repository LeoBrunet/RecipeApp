//
//  RecipeIntent.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import Foundation

//
//  RecipeIntent.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 01/03/2022.
//

import Foundation
import Combine

enum RecipeIntentState :  CustomStringConvertible, Equatable{
    case ready
    case recipeAdding
    case stepAdding
    
    var description: String{
        switch self{
        case .ready: return "state: .ready"
        case .recipeAdding: return "state: .recipeAdding"
        case .stepAdding: return "state .stepAdding"
        }
    }
}

enum RecipeListIntentState : CustomStringConvertible, Equatable{
    case ready
    case listUpdated
    case newElement(LightRecipe)
    
    var description: String{
        switch self {
        case .ready:
            return "list state: .ready"
        case .listUpdated:
            return "list state: .listUpdated"
        case .newElement(let rec):
            return "list state: .newElement(\(rec)"
        }
    }
}


struct RecipeIntent{
    // CurrentValueSubject : en fait un publisher qui garde en mémoire l'état en cours
    // "Never" : y aura jms d'erreur
    //   private var state = CurrentValueSubject<IntentState,Never>(.ready)
    // PassthroughSubject : un publisher qui passe les valeurs mais ne les mémorise pas
    // "Never" : jamais d'erreur de publication
    private var state = PassthroughSubject<RecipeIntentState,Never>()
    private var listState = PassthroughSubject<RecipeListIntentState,Never>()
    
    // Accès à la valeur de l'état si nécessaire : state.value
    
    //    func addObserver(viewModel: ViewModel) {
    func addObserver(viewModel: RecipeVM, listViewModel: LightRecipesVM){
        // reçoit VM qui veut être au courant des actions demandées (Intent)
        // ce VM souscrit aux publications (modifications) de l'état
        self.state.subscribe(viewModel)
        self.listState.subscribe(listViewModel)
    }
    
    func intentToAdd(recipe: LightRecipe) async -> Int?{
        self.state.send(.recipeAdding)
        let request : Result<LightRecipe, Error> = await LightRecipeDAO.createRecipe(recipe: recipe)
        switch(request){
        case .success(let rec):
            print("recipe updated in db")
            self.listState.send(.newElement(rec))
            return rec.numRecipe
        case .failure(let error):
            print(error)
            return nil
        }
    }
    
    func intentToAddSteps(recipe: RecipeVM) async{
        var res = await StepDAO.postSteps(recipe: recipe)
        print(res)
    }
}
