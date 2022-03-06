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
            return Step(numStep: stepDTO.numStep, name: recipeStep.name, description: recipeStep.description, ingredients: [], duration: recipeStep.duration)
        } else {
            let descriptionStep = stepDTO.descriptionStep!
            return Step(numStep: stepDTO.numStep, name: descriptionStep.nameStep, description: descriptionStep.description, ingredients: IngredientDAO.DTOListToIngredients(ingredientsDTO: descriptionStep.ingredients), duration: descriptionStep.duration)
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
}
