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
    
    static func RecipeToDTO(recipe: LightRecipe) -> LightRecipeDTO{
        return LightRecipeDTO(numRecipe: recipe.numRecipe, name: recipe.name, nbDiners: recipe.nbDiners, image: recipe.image, idCategory: recipe.category, description: recipe.description, ingredientCost: recipe.ingredientCost, duration: recipe.duration)
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
    
    static func getRecipe(numRecipe: Int) async -> Result<LightRecipe,Error>{
        let request : Result<LightRecipeDTO, JSONError> = await JSONHelper.get(url: "recipe/"+String(numRecipe))
        
        switch(request){

        case .success(let recipeDTO):
            print(recipeDTO)
            return .success(LightRecipeDAO.DTOToRecipe(recipeDTO: recipeDTO))


        case .failure(let error):
            print(error)
            return .failure(error)
        }
    }
    
    static func createRecipe(recipe: LightRecipe) async -> Result <LightRecipe, Error>{
        let request : Result<LightRecipeDTO, JSONError> = await URLSession.shared.create(urlEnd: "recipe/", data: RecipeToDTO(recipe: recipe))
        
        switch(request){

        case .success(let created):
            return .success(DTOToRecipe(recipeDTO: created))


        case .failure(let error):
            return .failure(error)
        }
    }
}
