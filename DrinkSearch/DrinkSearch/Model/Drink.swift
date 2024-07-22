//
//  Drink.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//

import Foundation
import CoreData

struct Drink: Codable, Identifiable {
    let idDrink: String?
    let strDrink: String?
    let strDrinkThumb: String?
    
    var id: String { idDrink ?? UUID().uuidString }
}

struct DrinkResponse: Codable {
    let drinks: [Drink]?
}
