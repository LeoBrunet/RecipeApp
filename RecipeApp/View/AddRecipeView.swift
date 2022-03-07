//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 05/03/2022.
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @ObservedObject var recipes: LightRecipesVM
    @ObservedObject var recipe: RecipeVM
    @State private var showingImagePicker = false
    @State private var image : Image?
    @State private var inputImage : UIImage?
    @State private var imageName : String?
    @State private var showView = false
    @State private var number = -1;
    var recipeIntent : RecipeIntent
    
    var numberF: NumberFormatter = {
        let formatteur = NumberFormatter()
        formatteur.numberStyle = .decimal
        return formatteur
    }()
    
    init(recipes: LightRecipesVM){
        self.recipes = recipes
        self.recipe = RecipeVM(model: LightRecipe(numRecipe: nil, name: "", nbDiners: 1, image: "", category: RecipeCategory.Entree, description: "", ingredientCost: nil, duration: nil), steps: [])
        self.recipeIntent = RecipeIntent()
        
        self.recipeIntent.addObserver(viewModel: recipe, listViewModel: recipes)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        recipe.image = (imageName ?? "") + ".jpg"
        print("IMAGE : " + recipe.image)
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                HStack{
                    ZStack{
                        Rectangle()
                            .fill(.secondary)
                        
                        Text("Choisir une image")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.width/2.5)
                            .clipped()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.width/2.5)
                    .cornerRadius(20)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    
                    VStack(alignment: .leading){
                        Spacer()
                        Group{
                            Text("Couverts").font(.headline)
                            HStack{
                                
                                Label("", systemImage: "fork.knife")
                                TextField("", value: $recipe.nbDiners, formatter: numberF)
                                    .padding(5)
                                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                    .cornerRadius(5)
                                    .multilineTextAlignment(.trailing)
                                Stepper("", value: $recipe.nbDiners, in: 1...99)
                            }
                            
                        }
                        
                        Spacer()
                        
                        Text("Catégorie").font(.headline)
                        Picker("", selection: $recipe.category) {
                            ForEach(RecipeCategory.allCases, id: \.self) { value in
                                Text(value.name).tag(value)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                        Spacer()
                        
                        
                    }
                }
                
                Group{
                    Text("Nom").font(.headline)
                    TextField("", text: $recipe.name)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                }
                
                Group{
                    Text("Description").font(.headline)
                    TextEditor(text: $recipe.description)
                        .padding(5)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5)
                        .frame(minHeight: UIScreen.main.bounds.height/4)
                }
                
            }.padding()
            Button(action: {
                Task{
                    URLSession.uploadImage(paramName: "file", fileName: recipe.image, image: inputImage!)
                    number = await self.recipeIntent.intentToAdd(recipe: recipe.model)!
                    showView = true
                }
                
                
            }, label: {
                Text("Ajouter")
            })
                .padding()
                .disabled(recipe.name.isEmpty || recipe.description.isEmpty || inputImage == nil)
            if showView{
                NavigationLink("", destination: StepsView(recipe: RecipeVM(model: LightRecipe(numRecipe: number, name: recipe.name, nbDiners: recipe.nbDiners, image: recipe.image, category: recipe.category, description: recipe.description, ingredientCost: nil, duration: nil), steps: []), recipes: recipes), isActive: $showView)
            }
            
            Spacer()
        }
        .navigationTitle("Ajouter une recette")
        .onChange(of: inputImage){_ in loadImage()}
        .sheet(isPresented: $showingImagePicker){
            ImagePicker(image : $inputImage, imageName: $imageName)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imageName: String?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            self.parent.imageName = provider.suggestedName
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
