//
//  FavoriteDrink.swift
//  DrinkSearch
//
//  Created by user252642 on 21/07/24.
//
import Foundation
import CoreData

@objc(FavoriteDrink)
public class FavoriteDrink: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var imageURL: String
}

extension FavoriteDrink {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteDrink> {
        return NSFetchRequest<FavoriteDrink>(entityName: "FavoriteDrink")
    }
}
