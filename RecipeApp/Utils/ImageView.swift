//
//  Image.swift
//  RecipeApp
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import SwiftUI

struct ImageView : View {
    var url: String
    
    init(url: String){
        self.url = url
    }
    
    var body : some View {
        AsyncImage(url: URL(string: url), transaction: Transaction(animation: .spring())) { phase in
            switch phase {
            case .empty:
                Color.purple.opacity(0.1)
         
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
         
            case .failure(_):
                Image(systemName: "exclamationmark.icloud")
                    .resizable()
                    .scaledToFit()
         
            @unknown default:
                Image(systemName: "exclamationmark.icloud")
            }
        }
        
    }
    
    
}
