//
//  StepDAO.swift
//  StepApp
//
//  Created by Leo Brunet on 05/03/2022.
//

import Foundation

struct StepDAO{
    
    static func DTOToStep(stepDTO: StepDTO) -> Step{
        if let recipeStep = stepDTO.RecipeStep {
            return Step(numStep: recipeStep.numRecipe, name: recipeStep.name, description: recipeStep.description, ingredients: [], duration: recipeStep.duration, isRecipe: true)
        } else {
            let descriptionStep = stepDTO.descriptionStep!
            return Step(numStep: stepDTO.numStep, name: descriptionStep.nameStep, description: descriptionStep.description, ingredients: IngredientDAO.DTOListToIngredients(ingredientsDTO: descriptionStep.ingredients), duration: descriptionStep.duration, isRecipe: false)
        }
    }
    
    static func DTOListToSteps(stepsDTO: [StepDTO]) -> [Step]{
        var steps : [Step] = []
        stepsDTO.forEach({
            steps.append(StepDAO.DTOToStep(stepDTO: $0))
        })
        return steps
    }
    
    
    static func getSteps(numRecipe: Int) async -> Result<[Step],Error>{
        let request : Result<[StepDTO], JSONError> = await JSONHelper.get(url: "generalStep/allOfRecipe/"+String(numRecipe))
        
        switch(request){

        case .success(let stepsDTO):
            print(stepsDTO)
            return .success(StepDAO.DTOListToSteps(stepsDTO: stepsDTO))


        case .failure(let error):
            print(error)
            return .failure(error)
        }
    }
    
    static func postSteps(recipe: RecipeVM) async -> Bool{
        var i = 1
        for step in recipe.steps{
            if step.isRecipe{
                let request : Result<StepPostDTO, JSONError> = await URLSession.shared.create(urlEnd: "generalStep/", data: StepPostDTO(position: i, recipeStep: step.numStep, proprietaryRecipe: recipe.numRecipe!))
                
                switch(request){

                case .success(_):
                    break

                case .failure(let error):
                    print(error)
                    
                }
            }
            else{
                var data = StepPostDTO(position: i, proprietaryRecipe: recipe.numRecipe!, nameStep: step.name, description: step.description, duration: step.duration)
                if step.ingredients.count > 0{
                    let ingredients = IngredientDAO.IngredientsToDTOPost(ingredients: step.ingredients)
                    data.ingredients = ingredients
                    print("Quantité : " + String(data.ingredients!.count))
                }
                let request : Result<StepPostDTO, JSONError> = await URLSession.shared.create(urlEnd: "generalStep/desc", data: data)
                
                switch(request){

                case .success(_):
                    break

                case .failure(let error):
                    print(error)
                }
            }
            i += 1
        }
        return true
    }
}
