//
//  CDCountriesTracker+CoreDataProperties.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 22/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation
import CoreData

extension CDCountriesTracker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCountriesTracker> {
        return NSFetchRequest<CDCountriesTracker>(entityName: "CDCountriesTrackerEntity");
    }

    @NSManaged public var memorised: String?
    @NSManaged public var remaining: String?

}
