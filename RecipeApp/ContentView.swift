//
//  ContentView.swift
//  RecipeApp
//
//  Created by m1 on 22/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeRecipeView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Recettes")
                }
            IngredientsView()
                .tabItem{
                    Image(systemName: "folder")
                    Text("Ingredients")
                }
            SalesView()
                .tabItem{
                    Image(systemName: "cart")
                    Text("Ventes")
                }
        }.accentColor(Color("Green"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
