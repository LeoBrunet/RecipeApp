//
//  SaleDTO.swift
//  RecipeApp
//
//  Created by Leo Brunet on 23/02/2022.
//

import Foundation

struct SaleDTO: Codable {
    struct LightRecipe: Codable {
        var name : String
    }
    var numSale: Int
    var quantity: Int
    var saleDate: Date
    var numRecipe: Int
    var cost: Double
    var price: Double
    
    let recipe: LightRecipe
}
//    var sale : Sale{
//        return Sale(numSale: numSale, quantity: quantity, date: date, numRecipe: numRecipe, nameRecipe: nameRecipe, cost: cost, price: price)
//    }
//
//    static func arraySale(salesDTO: [SaleDTO]) -> [Sale]{
//        var sales: [Sale] = []
//        for sale in salesDTO{
//            sales.append(sale.sale)
//        }
//        return sales
//    }
//
//    static func toArraySaleDTO(sales: [Sale]) -> [SaleDTO]{
//        let saleDTO: [SaleDTO] = sales.compactMap{(sale: Sale) -> SaleDTO in
//            return SaleDTO(numSale: sale.numSale, quantity: sale.quantity, date: sale.date, numRecipe: sale.numRecipe, nameRecipe: sale.nameRecipe, cost: sale.cost, price: sale.price)
//        }
//        return saleDTO
//    }
//}
//
//struct SalesDTO: Codable {
//    var resultCount: Int
//    var results: [SaleDTO]
//
//    var sales: [Sale] {
//        return SaleDTO.arraySale(salesDTO: self.results)
//    }
//}
