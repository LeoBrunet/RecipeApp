//
//  IngredientDAO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation

struct IngredientDAO{
    
    static func DTOToIngredient(ingDTO: IngredientDTO) -> Ingredient{
        if let ingredientInStep = ingDTO.ingredientInStep {
            return Ingredient(numIngredient: ingDTO.numIngredient, nameIngredient: ingDTO.nameIngredient, unitePrice: ingDTO.unitePrice, codeAllergen: ingDTO.codeAllergen, idType: ingDTO.idType, idUnit: ingDTO.idUnit, stock: ingDTO.stock, quantity: ingredientInStep.quantity)
        }
        else if let quantity = ingDTO.quantity{
            return Ingredient(numIngredient: ingDTO.numIngredient, nameIngredient: ingDTO.nameIngredient, unitePrice: ingDTO.unitePrice, codeAllergen: ingDTO.codeAllergen, idType: ingDTO.idType, idUnit: ingDTO.idUnit, stock: ingDTO.stock, quantity: quantity)
        }
        else {
            return Ingredient(numIngredient: ingDTO.numIngredient, nameIngredient: ingDTO.nameIngredient, unitePrice: ingDTO.unitePrice, codeAllergen: ingDTO.codeAllergen, idType: ingDTO.idType, idUnit: ingDTO.idUnit, stock: ingDTO.stock, quantity: 0)
        }
    }
    
    static func IngredientToDTO(ingredient: Ingredient) -> IngredientDTO{
        return IngredientDTO(numIngredient: ingredient.numIngredient, nameIngredient: ingredient.nameIngredient, unitePrice: ingredient.unitePrice, codeAllergen: ingredient.codeAllergen, idType: ingredient.idType, idUnit: ingredient.idUnit, stock: ingredient.stock)
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
    
    static func getIngredientsOfRecipe(recipeNum: Int) async -> Result<[Ingredient],Error>{
        let request : Result<[IngredientDTO], JSONError> = await JSONHelper.get(url: "recipe/ingredients/"+String(recipeNum))
        
        switch(request){
            
        case .success(let ingredientsDTO):
            return .success(IngredientDAO.DTOListToIngredients(ingredientsDTO: ingredientsDTO))
            
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func createIngredient(ingredient: Ingredient) async -> Result <Ingredient, Error>{
        let request : Result<IngredientDTO, JSONError> = await URLSession.shared.create(urlEnd: "ingredient/", data: IngredientToDTO(ingredient: ingredient))
        
        switch(request){
            
        case .success(let updated):
            return .success(DTOToIngredient(ingDTO: updated))
            
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    static func updateIngredient(ingredient: Ingredient) async -> Result <Bool, Error>{
        let request : Result<Bool, JSONError> = await URLSession.shared.update(urlEnd: "ingredient/" + String(ingredient.numIngredient!), data: IngredientToDTO(ingredient: ingredient))
        
        switch(request){
            
        case .success(let updated):
            return .success(updated)
            
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
