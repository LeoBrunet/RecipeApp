//
//  RecipeDAO.swift
//  RecipeApp
//
//  Created by Léo Brunet on 28/02/2022.
//

import Foundation

struct LightRecipeDAO{
    
    static func DTOToRecipe(recipeDTO: LightRecipeDTO) -> LightRecipe{
        return LightRecipe(numRecipe: recipeDTO.numRecipe, name: recipeDTO.name, nbDiners: recipeDTO.nbDiners, image: recipeDTO.image, category: recipeDTO.idCategory, description: recipeDTO.description, ingredientCost: recipeDTO.ingredientCost, duration: recipeDTO.duration)
    }
    
    static func DTOListToRecipes(recipesDTO: [LightRecipeDTO]) -> [LightRecipe]{
        var recipes : [LightRecipe] = []
        recipesDTO.forEach({
            recipes.append(LightRecipeDAO.DTOToRecipe(recipeDTO: $0))
        })
        return recipes
    }
    
    static func getRecipes() async -> Result<[LightRecipe],Error>{
        let request : Result<[LightRecipeDTO], JSONError> = await JSONHelper.get(url: "recipe")
        
        switch(request){

        case .success(let recipesDTO):
            print(recipesDTO)
            return .success(LightRecipeDAO.DTOListToRecipes(recipesDTO: recipesDTO))


        case .failure(let error):
            print(error)
            return .failure(error)
        }
    }
}
