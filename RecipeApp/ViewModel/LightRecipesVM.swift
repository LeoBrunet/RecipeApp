//
//  LightRecipeVM.swift
//  RecipeApp
//
//  Created by Leo Brunet on 28/02/2022.
//

import Foundation
import Combine

class LightRecipesVM : ObservableObject {
    
    @Published var recipes : [LightRecipe] = []
    
    func getAllRecipes() async {
        let request : Result<[LightRecipe], Error> = await LightRecipeDAO.getRecipes()
        
        switch(request){
            
        case .success(let recipes):
            self.recipes = recipes
            
        case .failure(let error):
            print(error)
        }
        
    }
    
}
