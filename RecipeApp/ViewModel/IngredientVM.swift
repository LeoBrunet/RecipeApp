//
//  IngredientVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation
import Combine

class IngredientVM: ObservableObject, Subscriber, IngredientObserver{
    
    private var model: Ingredient
    @Published var numIngredient: Int
    @Published var nameIngredient: String
    @Published var unitePrice: Double
    @Published var codeAllergen: Allergen?
    @Published var idType: IngredientType
    @Published var idUnit: IngredientUnit
    @Published var stock: Double
    
    init(model: Ingredient){
        self.model = model
        self.numIngredient = model.numIngredient
        self.nameIngredient = model.nameIngredient
        self.unitePrice = model.unitePrice
        self.codeAllergen = model.codeAllergen
        self.idType = model.idType
        self.idUnit = model.idUnit
        self.stock = model.stock
        
        self.model.ingredientObs = self
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
    func receive(_ input: IngredientIntentState) -> Subscribers.Demand {
        print("vm -> intent \(input)")
        switch input{
        case .ready:
            break
        case .ingredientNameChanging(let ingredientName):
            let ingredientNameClean = ingredientName.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change model name to '\(ingredientNameClean)'")
            self.model.nameIngredient = ingredientNameClean
            print("vm: model name changed to '\(self.model.nameIngredient)'")
        case .ingredientAllergenChanging(let allergen):
            self.model.codeAllergen = allergen
        case .ingredientTypeChanging(let type):
            self.model.idType = type
        case .ingredientStockChanging(let stock):
            self.model.stock = stock
        case .ingredientUnitChanging(let unit):
            self.model.idUnit = unit
        case .ingredientPriceChanging(let price):
            self.model.unitePrice = price
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
    
    typealias Input = IngredientIntentState
    typealias Failure = Never
    
    func changed(ingredientName: String) {
        self.nameIngredient = ingredientName
    }
    
    func changed(unitePrice: Double) {
        self.unitePrice = unitePrice
    }
    
    func changed(stock : Double) {
        self.stock = stock
    }
    
    func changed(codeAllergen  : Allergen) {
        self.codeAllergen = codeAllergen
    }
    
    func changed(type: IngredientType) {
        self.idType = type
    }
    
    func changed(unit: IngredientUnit) {
        self.idUnit = unit
    }
}
