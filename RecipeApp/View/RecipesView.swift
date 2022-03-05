//
//  RecipesView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct RecipesView: View {
    @StateObject var recipesVM: LightRecipesVM = LightRecipesVM()
    var category: RecipeCategory
    @State private var searchText = ""
    
    var recipes : [LightRecipe] {
        if searchText.isEmpty {
            return recipesVM.recipes.filter({$0.category == category})
        } else {
            return recipesVM.recipes.filter({$0.name.contains(searchText) && $0.category == category})
        }
    }
    
    var body: some View {
        VStack{
            ForEach(Array(recipes.enumerated()), id:\.element.numRecipe){ index, recipe in
                NavigationLink(destination: RecipeView(recipe: recipe)){
                    ProductCard(image: recipe.image, title: recipe.name, nbDiners: recipe.nbDiners, price: recipe.ingredientCost)
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear{
            if recipesVM.recipes.count == 0 {
                Task {
                    await recipesVM.getAllRecipes()
                }
            }
        }
        .navigationTitle(category.name)
        Spacer()
    }
}

struct ProductCard: View {
    
    var image: String
    var title: String
    var nbDiners: Int
    var price: Double
    
    var body: some View {
        HStack(alignment: .center) {
            CardImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+image)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Label(String(nbDiners), systemImage: "fork.knife")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text("€" + String.init(format: "%0.2f", price))
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}
