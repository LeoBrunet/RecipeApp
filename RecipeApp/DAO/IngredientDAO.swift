//
//  IngredientDAO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

struct IngredientDAO{
    
    static func DTOToIngredient(ingDTO: IngredientDTO) -> Ingredient{
        return Ingredient(numIngredient: ingDTO.numIngredient, nameIngredient: ingDTO.nameIngredient, unitePrice: ingDTO.unitePrice, codeAllergen: ingDTO.codeAllergen, idType: ingDTO.idType, idUnit: ingDTO.idUnit, stock: ingDTO.stock)
    }
    
    static func DTOListToIngredients(ingredientsDTO: [IngredientDTO]) -> [Ingredient]{
        var ingredients : [Ingredient] = []
        ingredientsDTO.forEach({
            ingredients.append(IngredientDAO.DTOToIngredient(ingDTO: $0))
        })
        return ingredients
    }
    
    static func getIngredients() async -> Result<[Ingredient],Error>{
        let request : Result<[IngredientDTO], JSONError> = await JSONHelper.get(url: "ingredient")
        
        switch(request){

        case .success(let ingredientsDTO):
            return .success(IngredientDAO.DTOListToIngredients(ingredientsDTO: ingredientsDTO))


        case .failure(let error):
            return .failure(error)
        }
    }
}
