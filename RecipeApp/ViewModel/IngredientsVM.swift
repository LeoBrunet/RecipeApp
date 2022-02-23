//
//  IngredientsVM.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import Foundation
import Combine

class IngredientsVM : ObservableObject {
    
    typealias Input = Never
    typealias Failure = Never
    
    @Published var ingredients : [Ingredient] = []
    
    func getAllIngredients() async {
        let request : Result<[Ingredient], Error> = await IngredientDAO.getIngredients()
        
        switch(request){

        case .success(let ingredients):
            self.ingredients = ingredients


        case .failure(let error):
            print(error)
        }
        
    }
}

