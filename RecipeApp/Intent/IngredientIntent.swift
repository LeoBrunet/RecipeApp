//
//  IngredientIntent.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 01/03/2022.
//

import Foundation
import Combine

enum IngredientIntentState :  CustomStringConvertible, Equatable{
    case ready
    case ingredientNameChanging(String)
    case ingredientAllergenChanging(Allergen)
    case ingredientTypeChanging(IngredientType)
    case ingredientStockChanging(Double)
    case ingredientUnitChanging(IngredientUnit)
    case ingredientPriceChanging(Double)
    case ingredientUpdating
    
    var description: String{
        switch self{
        case .ready: return "state: .ready"
        case .ingredientNameChanging(let name): return "state: .ingredientNameChanging(\(name))"
        case .ingredientAllergenChanging(let allergen): return "state: .ingredientAllergenChanging(\(allergen.name))"
        case .ingredientTypeChanging(let type): return "state: .ingredientTypeChanging(\(type.name))"
        case .ingredientStockChanging(let stock): return "state: .ingredientStockChanging(\(stock))"
        case .ingredientUnitChanging(let unit): return "state: .ingredientUnitChanging(\(unit.name))"
        case .ingredientPriceChanging(let price): return "state: .ingredientPriceChanging(\(price))"
        case .ingredientUpdating: return "state: .ingredientUpdating"
        }
    }
}

enum IngredientListIntentState : CustomStringConvertible, Equatable{
    case ready
    case listUpdated
    
    var description: String{
        switch self {
        case .ready:
            return "list state: .ready"
        case .listUpdated:
            return "list state: .listUpdated"
        }
    }
}


struct IngredientIntent{
    // CurrentValueSubject : en fait un publisher qui garde en mémoire l'état en cours
    // "Never" : y aura jms d'erreur
    //   private var state = CurrentValueSubject<IntentState,Never>(.ready)
    // PassthroughSubject : un publisher qui passe les valeurs mais ne les mémorise pas
    // "Never" : jamais d'erreur de publication
    private var state = PassthroughSubject<IngredientIntentState,Never>()
    private var listState = PassthroughSubject<IngredientListIntentState,Never>()
    
    // Accès à la valeur de l'état si nécessaire : state.value
    
    //    func addObserver(viewModel: ViewModel) {
    func addObserver(viewModel: IngredientVM, listViewModel: IngredientsVM){
        // reçoit VM qui veut être au courant des actions demandées (Intent)
        // ce VM souscrit aux publications (modifications) de l'état
        self.state.subscribe(viewModel)
        self.listState.subscribe(listViewModel)
    }
    
    func intentToChange(ingredientName: String){
        // Fait deux choses en 1 instruction (cf specif Combine) :
        //  1) change la valeur (car on un CurrentVal... doit mémoriser la valeur en cours)
        // 2) avertit les subsscriber que l'état a changé
        self.state.send(.ingredientNameChanging(ingredientName))
        self.listState.send(.listUpdated)
    }
    
    func intentToChange(unitePrice: Double){
        self.state.send(.ingredientPriceChanging(unitePrice))
    }
    
    func intentToChange(unit: IngredientUnit){
        self.state.send(.ingredientUnitChanging(unit))
        self.listState.send(.listUpdated)
    }
    
    func intentToChange(allergen: Allergen){
        self.state.send(.ingredientAllergenChanging(allergen))
    }
    
    func intentToChange(stock: Double){
        self.state.send(.ingredientStockChanging(stock))
        self.listState.send(.listUpdated)
    }
    
    func intentToChange(type: IngredientType){
        self.state.send(.ingredientTypeChanging(type))
        self.listState.send(.listUpdated)
    }
    
    func intentToUpdate(ingredient: Ingredient) async{
        self.state.send(.ingredientUpdating)
        let request : Result<Bool, Error> = await IngredientDAO.updateIngredient(ingredient: ingredient)
        switch(request){
        case .success(_):
            print("ingredient updated in db")
            self.listState.send(.listUpdated)
        case .failure(let error):
            print(error)
            
        }
    }
}
