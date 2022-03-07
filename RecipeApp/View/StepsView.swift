//
//  StepsView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 06/03/2022.
//

import SwiftUI

struct StepsView: View {
    
    @ObservedObject var recipe: RecipeVM
    @ObservedObject var recipes: LightRecipesVM
    @State private var editMode = EditMode.active
    @State var isAddRecipeShown: Bool = false
    @State var isAddDescriptionShown: Bool = false
    var recipeIntent : RecipeIntent
    
    init(recipe: RecipeVM, recipes: LightRecipesVM){
        self.recipe = recipe
        self.recipes = recipes
        self.recipeIntent = RecipeIntent()
        self.recipeIntent.addObserver(viewModel: self.recipe, listViewModel: self.recipes)
    }
    
    var body: some View {
        VStack{
            List {
                ForEach(Array(recipe.steps.enumerated()), id:\.element.hashValue){ index, step in
                    if(step.isRecipe){
                        Text("Faire la recette : " + step.name)
                    }
                    else{
                        Text(step.name)
                    }
                    
                }
                .onMove(perform: onMove)
                .onDelete(perform: onDelete)
            }
            .deleteDisabled(false)
        
            Button("Finaliser"){
                Task{
                    await self.recipeIntent.intentToAddSteps(recipe: recipe)
                    NavigationUtil.popToRootView()
                }
            }
        }
        .accentColor(Color("Green"))
        .navigationTitle("Ajouter des étapes")
        .environment(\.editMode, $editMode)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            Group{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Ajouter une recette"){
                        isAddRecipeShown = true
                    }
                    .sheet(isPresented: $isAddRecipeShown){
                        AddRecipeStepView(recipe: self.recipe, recipes: self.recipes)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Ajouter une étape"){
                        isAddDescriptionShown = true
                    }
                    .sheet(isPresented: $isAddDescriptionShown){
                        AddDescriptionStepView(recipe: self.recipe, recipes: self.recipes)
                    }
                }
            }
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        recipe.steps.remove(atOffsets: offsets)
    }
    
    // 3.
    private func onMove(source: IndexSet, destination: Int) {
        recipe.steps.move(fromOffsets: source, toOffset: destination)
    }
}

struct AddRecipeStepView: View{
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipes: LightRecipesVM
    @ObservedObject var recipe: RecipeVM
    //var ingredientIntent : IngredientIntent
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(recipe: RecipeVM, recipes: LightRecipesVM){
        self.recipe = recipe
        self.recipes = recipes
        //        self.ingredientIntent = IngredientIntent()
        //
        //        self.ingredientIntent.addObserver(viewModel: self.ingredient, listViewModel: self.ingredients)
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(Array(recipes.recipes.enumerated()), id:\.element.numRecipe){ index, rec in
                    Button(action: {
                        recipe.steps.append(Step(numStep: rec.numRecipe!, name: rec.name, description: rec.description, ingredients: [], duration: nil, isRecipe: true))
                        dismiss()
                    }, label: {Label(rec.name, systemImage: "")})
                }
            }
            .accentColor(Color("Green"))
            .navigationTitle("Ajouter une étape recette")
            .toolbar{
                Button("Annuler") {
                    dismiss()
                }
            }
        }
        
    }
}

struct AddDescriptionStepView: View{
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipes: LightRecipesVM
    @ObservedObject var recipe: RecipeVM
    @ObservedObject var step = Step(numStep: nil, name: "", description: "", ingredients: [], duration: 5, isRecipe: false)
    @ObservedObject var ingredients = IngredientsVM()
    @State var ingredient = Ingredient(numIngredient: 0, nameIngredient: "nokfnv", unitePrice: 0, codeAllergen: nil, idType: IngredientType.Champignon, idUnit: IngredientUnit.Botte, stock: 0, quantity: 0 )
    @State var quantity: Double = 0
    //var ingredientIntent : IngredientIntent
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(recipe: RecipeVM, recipes: LightRecipesVM){
        self.recipe = recipe
        self.recipes = recipes
        //        self.ingredientIntent = IngredientIntent()
        //
        //        self.ingredientIntent.addObserver(viewModel: self.ingredient, listViewModel: self.ingredients)
    }
    
    func delete(at offsets: IndexSet) {
        step.ingredients.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    HStack{
                        VStack(alignment: .leading){
                            Text("Nom").font(.headline)
                            TextField("", text: $step.name)
                                .padding(5)
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .cornerRadius(5)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Durée").font(.headline)
                            TextField("", value: $step.duration, formatter: numberF)
                                .padding(5)
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .cornerRadius(5)
                        }
                    }
                    
                    Group{
                        Text("Description").font(.headline)
                        TextEditor(text: $step.description)
                            .padding(5)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5)
                            .frame(minHeight: UIScreen.main.bounds.height/6)
                    }
                    
                    Group{
                        Text("Ingrédient").font(.headline)
                        List{
                            Picker("Ingrédient", selection: $ingredient){
                                ForEach(ingredients.ingredients, id: \.numIngredient) { value in
                                    Text(value.nameIngredient + " (\(value.idUnit.name))").tag(value)
                                }
                            }
                            
                            TextField("Quantité", value: $quantity, formatter: numberF)
                            Button("Ajouter l'ingrédient"){
                                step.ingredients.append(Ingredient(numIngredient: ingredient.numIngredient, nameIngredient: ingredient.nameIngredient, unitePrice: ingredient.unitePrice, codeAllergen: ingredient.codeAllergen, idType: ingredient.idType, idUnit: ingredient.idUnit, stock: ingredient.stock, quantity: quantity))
                            }
                        }.frame(minHeight: UIScreen.main.bounds.height/6)
                        
                        List{
                            ForEach(step.ingredients, id: \.numIngredient) { value in
                                HStack{
                                    Text(value.nameIngredient)
                                    Spacer()
                                    Text(String(value.quantity ?? 0))
                                    Text(value.idUnit.name)
                                }
                                
                            }
                            .onDelete(perform: delete)
                        }.frame(minHeight: UIScreen.main.bounds.height/6)
                    }
                }.padding()
                Button("Ajouter"){
                    self.recipe.steps.append(step)
                    dismiss()
                }
                
            }
            .onAppear{
                if ingredients.ingredients.count == 0 {
                    Task{
                        await ingredients.getAllIngredients()
                        ingredient = ingredients.ingredients.first!
                    }
                }
            }
            .accentColor(Color("Green"))
            .navigationTitle("Ajouter une étape recette")
            .toolbar{
                Button("Annuler") {
                    dismiss()
                }
            }
        }
        
    }
}

struct NavigationUtil {
  static func popToRootView() {
    findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}
