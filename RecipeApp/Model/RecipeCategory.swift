//
//  RecipeCategory.swift
//  RecipeApp
//
//  Created by Leo Brunet on 28/02/2022.
//

import Foundation

enum RecipeCategory: Int, Codable, CaseIterable, Identifiable {
    var id: Int { self.rawValue }
    
    case Entree = 1
    case Plat = 2
    case Dessert = 3
    case Autre = 4
    
    var name: String{
        switch self{
        case .Entree:
            return "Entrée"
        case .Plat:
            return "Plat"
        case .Dessert:
            return "Dessert"
        case .Autre:
            return "Autre"
        }
    }
}
