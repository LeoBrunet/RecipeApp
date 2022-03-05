//
//  HomeRecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//

import SwiftUI

struct HomeRecipeView: View {
    
    @StateObject var recipesVM: LightRecipesVM = LightRecipesVM()
    let gradient = Gradient(colors: [.black, .clear])
    
    var firstRecipes: [LightRecipe] {
        return self.recipesVM.recipes.suffix(3)
    }
    
    var lastRecipe: LightRecipe? {
        return self.recipesVM.recipes.max(by: {$0.numRecipe < $1.numRecipe})
    }
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(firstRecipes.enumerated()), id:\.element.numRecipe){ index, recipe in
                                NavigationLink(destination: RecipeView(recipe: recipe)){
                                    ZStack(alignment: .bottomLeading){
                                        ImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+recipe.image).frame(width: 200, height: 200)
                                        LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: UnitPoint(x: 0.5, y: 0.5)).frame(width: 200, height:200)
                                        Text(recipe.name).padding(10).foregroundColor(.white)
                                    }.cornerRadius(5)
                                }
                            }
                            /*ForEach(0..<10) {_ in
                             ZStack(alignment: .bottomLeading){
                             ImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/saint_honore-2.jpg")
                             LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: UnitPoint(x: 0.5, y: 0.5)).frame(width: 200, height:200)
                             Text("Saint-honoré").padding(10).foregroundColor(.white)
                             }.cornerRadius(5)
                             }*/
                        }
                    }
                    VStack(alignment:.leading){
                        Spacer()
                        Text("Catégories").font(.title2)
                        HStack{
                            ForEach(RecipeCategory.allCases) { category in
                                NavigationLink(destination: RecipesView(category: category)){
                                    Text(category.name)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(10)
                                        .background(Color("Green"))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                    VStack(alignment:.leading){
                        if let lastRecipe = lastRecipe {
                            Text("Dernière recette").font(.title2)
                            HStack{
                                ImageView(url: "https://nicolas-ig.alwaysdata.net/api/file/"+lastRecipe.image).frame(width: 200, height: 200)
                                VStack(alignment: .leading){
                                    Text(lastRecipe.name).bold()
                                    Text(lastRecipe.description).font(.system(size: 14))
                                    Spacer()
                                }.padding(5)
                                Spacer()
                            }.background(.gray.opacity(0.1)).cornerRadius(5)
                        }
                    }
                    
                }.padding(20).navigationTitle("RecipeApp").background(.clear)
            }.onAppear{
                if recipesVM.recipes.count == 0 {
                    Task {
                        await recipesVM.getAllRecipes()
                    }
                }
            }
        }
    }
}

struct HomeRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeRecipeView()
    }
}
