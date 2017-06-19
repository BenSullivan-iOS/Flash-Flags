//
//  CDCountriesForGame+CoreDataProperties.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 22/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation
import CoreData

extension CDCountriesForGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCountriesForGame> {
        return NSFetchRequest<CDCountriesForGame>(entityName: "CDCountriesForGame");
    }

    @NSManaged public var country: String?
    @NSManaged public var cdgame: CDGame?
}
