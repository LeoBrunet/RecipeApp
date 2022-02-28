
//  SalesVM.swift
//  RecipeApp
//
//  Created by etud on 22/02/2022.
//
import Foundation
import Combine

class SalesVM : ObservableObject {
    
    @Published var sales : [Sale] = []
    
    func getAllSales() async {
        let request : Result<[Sale], Error> = await SaleDAO.getSales()
        
        switch(request){
            
        case .success(let sales):
            self.sales = sales
            
            
        case .failure(let error):
            print(error)
        }
        
    }
    
}
