//
//  DrinkService.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//

import Foundation

class DrinkService {
    static let shared = DrinkService()
    private init() {}
    
    func searchDrinks(name: String) async throws -> [Drink] {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(name)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(DrinkResponse.self, from: data)
        return response.drinks ?? []
    }
}
