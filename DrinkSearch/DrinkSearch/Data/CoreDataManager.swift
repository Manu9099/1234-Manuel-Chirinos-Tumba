//
//  CoreDataManager.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DrinkModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func saveFavoriteDrink(_ drink: Drink) {
        let favoriteDrink = FavoriteDrink(context: managedContext)
        favoriteDrink.id = drink.idDrink ?? UUID().uuidString
        favoriteDrink.name = drink.strDrink ?? "Nombre desconocido"
        favoriteDrink.imageURL = drink.strDrinkThumb ?? ""
        
        do {
            try managedContext.save()
        } catch {
            print("Error saving favorite drink: \(error)")
        }
    }
    
    func removeFavoriteDrink(_ drink: Drink) {
        guard let drinkId = drink.idDrink else { return }
        
        let fetchRequest: NSFetchRequest<FavoriteDrink> = FavoriteDrink.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", drinkId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                managedContext.delete(result)
            }
            try managedContext.save()
        } catch {
            print("Error removing favorite drink: \(error)")
        }
    }
    func isFavoriteDrink(_ drink: Drink) -> Bool {
        guard let drinkId = drink.idDrink else { return false }
        
        let fetchRequest: NSFetchRequest<FavoriteDrink> = FavoriteDrink.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", drinkId)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    func fetchFavoriteDrinks() -> [Drink] {
        let fetchRequest: NSFetchRequest<FavoriteDrink> = FavoriteDrink.fetchRequest()
        
        do {
            let favoriteDrinks = try managedContext.fetch(fetchRequest)
            return favoriteDrinks.map { Drink(idDrink: $0.id, strDrink: $0.name, strDrinkThumb: $0.imageURL) }
        } catch {
            print("Error fetching favorite drinks: \(error)")
            return []
        }
    }
    
    
}
