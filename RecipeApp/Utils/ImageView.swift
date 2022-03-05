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

struct CardImageView : View {
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
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .frame(width: 100)
                    .padding(.all, 20)
                    
         
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

struct TopImageView : View {
    var url: String
    var geometry: GeometryProxy
    
    init(url: String, geometry: GeometryProxy){
        self.url = url
        self.geometry = geometry
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
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(y: geometry.frame(in: .global).minY/9)
                    .clipped()
         
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

struct OtherTopImageView : View {
    var url: String
    var geometry: GeometryProxy
    
    init(url: String, geometry: GeometryProxy){
        self.url = url
        self.geometry = geometry
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
                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                    .clipped()
                    .offset(y: -geometry.frame(in: .global).minY)
         
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


    
