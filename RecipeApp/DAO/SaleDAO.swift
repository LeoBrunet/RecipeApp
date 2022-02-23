//
//  IngredientDAO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

struct SaleDAO{
    
    static func DTOToSale(saleDTO: SaleDTO) -> Sale{
        return Sale(numSale: saleDTO.numSale, quantity: saleDTO.quantity, date: saleDTO.saleDate, numRecipe: saleDTO.numRecipe, nameRecipe: saleDTO.recipe.name, cost: saleDTO.cost, price: saleDTO.price)
    }
    
    static func DTOListToSales(salesDTO: [SaleDTO]) -> [Sale]{
        var sales : [Sale] = []
        salesDTO.forEach({
            sales.append(SaleDAO.DTOToSale(saleDTO: $0))
        })
        return sales
    }
    
    static func getSales() async -> Result<[Sale],Error>{
        let request : Result<[SaleDTO], JSONError> = await JSONHelper.get(url: "sale")
        
        switch(request){

        case .success(let salesDTO):
            return .success(SaleDAO.DTOListToSales(salesDTO: salesDTO))


        case .failure(let error):
            return .failure(error)
        }
    }
}
