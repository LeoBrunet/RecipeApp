//
//  RecipeDAO.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import Foundation

struct RecipeDAO{
    static func createRecipe(recipe: Recipe) async -> Result <Recipe, Error>{
        let request : Result<IngredientDTO, JSONError> = await URLSession.shared.create(urlEnd: "ingredient/", data: IngredientToDTO(ingredient: ingredient))
        
        switch(request){

        case .success(let updated):
            return .success(DTOToRecipe(recipeDTO: <#T##LightRecipeDTO#>))


        case .failure(let error):
            return .failure(error)
        }
    }
}
