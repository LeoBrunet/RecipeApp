//
//  IngredientVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

class IngredientVM: ObservableObject{
    
    typealias Input = Never
    typealias Failure = Never
    
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
    }
    
}
