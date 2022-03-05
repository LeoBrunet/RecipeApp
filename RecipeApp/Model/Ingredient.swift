//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

enum Allergen: Int, Codable, CaseIterable{
    case Aucun = 0
    case Arachide = 1
    case Céleri = 2
    case Crabe = 3
    case Gluten = 4
    case Fruit = 5
    case Lait = 6
    case Lapin = 7
    case Oeuf = 8
    case Poisson = 9
    case Mollusques = 10
    case Moutarde = 11
    case Sésame = 12
    case Soja = 13
    case Sulfites = 14
    
    var name: String {
        switch self{
        case .Aucun:
            return "Aucun"
        case .Arachide:
            return "Arachide"
        case .Céleri:
            return "Céleri"
        case .Crabe:
            return "Crabe"
        case .Gluten:
            return "Gluten"
        case .Fruit:
            return "Fruit à coque"
        case .Lait:
            return "Lait"
        case .Lapin:
            return "Lapin"
        case .Oeuf:
            return "Oeuf"
        case .Poisson:
            return "Poisson"
        case .Mollusques:
            return "Mollusque"
        case .Moutarde:
            return "Moutarde"
        case .Sésame:
            return "Sésame"
        case .Soja:
            return "Soja"
        case .Sulfites:
            return "Sulfite"
        }
    }
    
}

enum IngredientType: Int, Codable, CaseIterable{
    case Autre = 1
    case Poisson = 2
    case Viande = 3
    case Crustacé = 4
    case Fromage = 5
    case Fruit = 6
    case Légume = 7
    case Champignon = 8
    case Liquide = 9
    
    var name: String{
        switch self{
        case .Autre:
            return "Autre"
        case .Poisson:
            return "Poisson"
        case .Viande:
            return "Viande"
        case .Crustacé:
            return "Crustacé"
        case .Fromage:
            return "Fromage"
        case .Fruit:
            return "Fruit"
        case .Légume:
            return "Légume"
        case .Champignon:
            return "Champignon"
        case .Liquide:
            return "Liquide"
        }
    }
    
    var icon: String{
        switch self{
        case .Autre:
            return "food"
        case .Poisson:
            return "fish"
        case .Viande:
            return "meat"
        case .Crustacé:
            return "shrimp"
        case .Fromage:
            return "cheese"
        case .Fruit:
            return "harvest"
        case .Légume:
            return "vegetable"
        case .Champignon:
            return "mushroom"
        case .Liquide:
            return "wine-bottles"
        }
    }
}

enum IngredientUnit: Int, Codable, CaseIterable{
    case kg = 1
    case l = 2
    case Pièce = 3
    case Unité = 4
    case Botte = 5
    case Pincée = 6
    
    var name: String {
        switch self{
            case .kg:
                return "kg"
            case .l:
                return "l"
            case .Pièce:
                return "pce"
            case .Unité:
                return "unt"
            case .Botte:
                return " bt"
            case .Pincée:
                return " pincée"
        }
    }
}

protocol IngredientObserver{
   func changed(ingredientName: String)
    func changed(unitePrice: Double)
    func changed(stock : Double)
    func changed(codeAllergen  : Allergen)
    func changed(type: IngredientType)
    func changed(unit: IngredientUnit)
}

class Ingredient : Comparable{
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.numIngredient == rhs.numIngredient
    }
    
    var ingredientObs: IngredientObserver?
    var numIngredient: Int?
    var nameIngredient: String {
        didSet{
            self.ingredientObs?.changed(ingredientName: self.nameIngredient)
        }
    }
    var unitePrice: Double{
        didSet{
            self.ingredientObs?.changed(unitePrice: self.unitePrice)
        }
    }
    var codeAllergen: Allergen?{
        didSet{
            self.ingredientObs?.changed(codeAllergen: self.codeAllergen ?? Allergen.Aucun)
        }
    }
    var idType: IngredientType{
        didSet{
            self.ingredientObs?.changed(type: self.idType)
        }
    }
    var idUnit: IngredientUnit{
        didSet{
            self.ingredientObs?.changed(unit: self.idUnit)
        }
    }
    var stock: Double{
        didSet{
            self.ingredientObs?.changed(stock: self.stock)
        }
    }
    var quantity: Int?
    
    static func <(lhs: Ingredient, rhs: Ingredient) -> Bool {
            lhs.nameIngredient < rhs.nameIngredient
        }
    
    init(numIngredient: Int?, nameIngredient: String, unitePrice: Double, codeAllergen: Allergen? = nil, idType: IngredientType, idUnit: IngredientUnit, stock: Double, quantity: Int? = 0) {
        self.numIngredient = numIngredient
        self.nameIngredient = nameIngredient
        self.unitePrice = unitePrice
        self.codeAllergen = codeAllergen
        self.idType = idType
        self.idUnit = idUnit
        self.stock = stock
        self.quantity = quantity
    }
    
    static func getSectionedDictionary(ingredients: [Ingredient]) -> Dictionary <String , [Ingredient]> {
            let sectionDictionary: Dictionary<String, [Ingredient]> = {
                return Dictionary(grouping: ingredients, by: {
                    let name = $0.nameIngredient
                    let normalizedName = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                    let firstChar = String(normalizedName.first!).uppercased()
                    return firstChar
                })
            }()
            return sectionDictionary
        }
    
}
