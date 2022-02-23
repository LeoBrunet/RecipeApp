//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

enum Allergen: Int, Codable{
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

enum IngredientType: Int, Codable{
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
            return "CHampignon"
        case .Liquide:
            return "Liquide"
        }
    }
}

enum IngredientUnit: Int, Codable{
    case kg = 1
    case l = 2
    case Pièce = 3
    case Unité = 4
    case Botte = 5
    case Pincée = 6
}

class Ingredient{
    
    var numIngredient: Int
    var nameIngredient: String
    var unitePrice: Double
    var codeAllergen: Allergen?
    var idType: IngredientType
    var idUnit: IngredientUnit
    var stock: Double
    
    init(numIngredient: Int, nameIngredient: String, unitePrice: Double, codeAllergen: Allergen? = nil, idType: IngredientType, idUnit: IngredientUnit, stock: Double) {
        self.numIngredient = numIngredient
        self.nameIngredient = nameIngredient
        self.unitePrice = unitePrice
        self.codeAllergen = codeAllergen
        self.idType = idType
        self.idUnit = idUnit
        self.stock = stock
    }
    
}
