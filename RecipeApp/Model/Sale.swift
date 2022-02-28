//  Sell.swift
//  RecipeApp
//
//  Created by Leo Brunet on 22/02/2022.
//
import Foundation
import UIKit

class Sale {
    var numSale: Int
    var quantity: Int
    var date: Date
    var numRecipe: Int
    var nameRecipe: String
    var cost: Double
    var price: Double
    
    init(numSale: Int, quantity: Int, date: Date, numRecipe: Int, nameRecipe: String, cost: Double, price: Double) {
        self.numSale = numSale
        self.quantity = quantity
        self.date = date
        self.numRecipe = numRecipe
        self.nameRecipe = nameRecipe
        self.cost = cost
        self.price = price
    }
}
