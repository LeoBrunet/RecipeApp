//
//  SalesView.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 22/02/2022.
//
import SwiftUI

struct SalesView: View {
    @StateObject var salesVM: SalesVM = SalesVM()
    @State private var searchText: String = ""
    let dateFormatter = DateFormatter()
    
    init(){
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(Array(searchResults.enumerated()), id:\.element.numSale){ index, sale in
                        HStack{
                            VStack(alignment: .leading){
                                Text(sale.nameRecipe).bold()
                                Text(dateFormatter.string(from: sale.date))
                            }
                            Spacer()
                            VStack{
                                HStack{
                                    Text(String(sale.quantity))
                                    Text("pour")
                                    Text(String(sale.price)+"€")
                                }
                                Text("Coût: "+String(sale.cost)+"€")
                            }
                        }
                    }.onDelete{
                        indexSet in
                        salesVM.sales.remove(atOffsets: indexSet)
                    }
                }.searchable(text: $searchText)
                    .onAppear{
                        if salesVM.sales.count == 0 {
                            Task {
                                await salesVM.getAllSales()
                            }
                        }
                    }.refreshable {
                        Task {
                            await salesVM.getAllSales()
                        }
                    }
            }.navigationTitle("Ventes")
        }
    }
    
    var searchResults: [Sale] {
        if searchText.isEmpty {
            return salesVM.sales
        } else {
            return self.salesVM.sales.filter({$0.nameRecipe.contains(searchText)})
        }
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView().environment(\.locale, Locale(identifier: "fr"))
    }
}
