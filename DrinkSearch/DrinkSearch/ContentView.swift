//
//  ContentView.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DrinkViewModel()
    
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "star.fill")
                }
        }
        .environmentObject(viewModel)
    }
}

struct SearchView: View {
    @EnvironmentObject var viewModel: DrinkViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: performSearch)
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if viewModel.drinks.isEmpty {
                    Text("No se encontraron bebidas")
                } else {
                    List(viewModel.drinks) { drink in
                        DrinkRow(drink: drink, isFavorite: viewModel.isFavorite(drink: drink)) {
                            viewModel.toggleFavorite(drink: drink)
                        }
                    }
                }
            }
            .navigationTitle("Buscador de Bebidas")
        }
    }
    
    private func performSearch() {
        viewModel.searchDrinks(name: searchText)
    }
}

struct FavoritesView: View {
    @EnvironmentObject var viewModel: DrinkViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.favoriteDrinks) { drink in
                DrinkRow(drink: drink, isFavorite: true) {
                    viewModel.toggleFavorite(drink: drink)
                }
            }
            .navigationTitle("Favoritos")
            .onAppear {
                viewModel.fetchFavoriteDrinks()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Buscar bebidas", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}

struct DrinkRow: View {
    let drink: Drink
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: drink.strDrinkThumb!)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            Text(drink.strDrink!)
            
            Spacer()
            
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }
        }
    }
}
