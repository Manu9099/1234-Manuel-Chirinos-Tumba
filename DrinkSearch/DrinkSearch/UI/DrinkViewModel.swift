//
//  DrinkViewModel.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//

import SwiftUI

class DrinkViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var favoriteDrinks: [Drink] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchFavoriteDrinks()
    }
    
    func searchDrinks(name: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await DrinkService.shared.searchDrinks(name: name)
                DispatchQueue.main.async {
                    self.drinks = result
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al buscar bebidas: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func toggleFavorite(drink: Drink) {
        if isFavorite(drink: drink) {
            coreDataManager.removeFavoriteDrink(drink)
        } else {
            coreDataManager.saveFavoriteDrink(drink)
        }
        fetchFavoriteDrinks()
    }
    
    func isFavorite(drink: Drink) -> Bool {
        return coreDataManager.isFavoriteDrink(drink)
    }
    
    func fetchFavoriteDrinks() {
        favoriteDrinks = coreDataManager.fetchFavoriteDrinks()
    }
}
