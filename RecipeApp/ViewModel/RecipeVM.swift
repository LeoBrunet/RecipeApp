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

    @Published var steps : [Step]
    @Published var numRecipe: Int?
    @Published var name: String
    @Published var nbDiners: Int
    @Published var image: String
    @Published var category: RecipeCategory
    @Published var description: String
    var ingredientCost: Double?
    var duration: Int?
    
    @Published var steps : [Step]
    @Published var ingredients : [Ingredient] = []
    
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
        
        if let ingredientCost = ingredientCost {
            self.ingredientCost = Double(round(100*ingredientCost)/100)
            self.flavoringCost =  Double(round(100*(ingredientCost*0.05))/100)
            self.productCost = Double(round(100*(ingredientCost + flavoringCost))/100)
            self.personnelCost = Double(round(100*(Double(duration!) * averageMinuteRate))/100)
            self.fluidCost = Double(round(100*(Double(duration!) * averageMinuteRateFluid))/100)
            self.chargesCost = Double(round(100*(personnelCost + fluidCost))/100)
            self.totalCost = Double(round(100*(chargesCost + productCost))/100)
            
            self.price = Double(round(100*(totalCost*sellingPriceMultiplierCoefficient))/100)
        } else {
            self.ingredientCost = 0
            self.flavoringCost =  0
            self.productCost = 0
            self.personnelCost = 0
            self.fluidCost = 0
            self.chargesCost = 0
            self.totalCost = 0
            
            self.price = 0
        }
        
    }
    

    let averageMinuteRate: Double = 0.175
    let averageMinuteRateFluid: Double = 0.0198
    let sellingPriceMultiplierCoefficient: Double = 1.3
    
    var flavoringCost: Double
    var productCost: Double
    var personnelCost: Double
    var fluidCost: Double
    var chargesCost: Double
    var totalCost: Double
    
    var price: Double
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
    
    func getIngredientsOfRecipe(recipeNum: Int) async {
        let request : Result<[Ingredient], Error> = await IngredientDAO.getIngredientsOfRecipe(recipeNum: recipeNum)
        
        switch(request){

        case .success(let ingredients):
            self.ingredients = ingredients

        case .failure(let error):
            print(error)
        }
    }
    
    func sell(sale: Sale) async -> Bool {
        
        let request : Result<Sale, Error> = await SaleDAO.sell(sale: sale)
        switch(request){
        case .success(_):
            print("sale made")
            return true
            
        case .failure(let error):
            print(error)
            return false
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
            self.model.numRecipe = self.numRecipe
            self.model.name = self.name
            self.model.nbDiners = self.nbDiners
            self.model.image = self.image
            self.model.category = self.category
            self.model.description = self.description
            self.model.ingredientCost = self.ingredientCost
            self.model.duration = self.duration
        case .stepAdding:
            break
        }
    
        

        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
