//
//  DrinkSearchApp.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//
import SwiftUI

@main
struct DrinkSearchApp: App {
    let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.managedContext)
        }
    }
}
