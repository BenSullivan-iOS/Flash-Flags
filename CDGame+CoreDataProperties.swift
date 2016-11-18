//
//  CDGame+CoreDataProperties.swift
//  
//
//  Created by Ben Sullivan on 18/11/2016.
//
//

import Foundation
import CoreData


extension CDGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGame> {
        return NSFetchRequest<CDGame>(entityName: "CDGame");
    }

    @NSManaged public var attempts: Double
    @NSManaged public var customGameTitle: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateLastCompleted: NSDate?
    @NSManaged public var highestPercentage: Double
    @NSManaged public var subject: String?
    @NSManaged public var cdcountriesforgame: NSSet?

}

// MARK: Generated accessors for cdcountriesforgame
extension CDGame {

    @objc(addCdcountriesforgameObject:)
    @NSManaged public func addToCdcountriesforgame(_ value: CDCountriesForGame)

    @objc(removeCdcountriesforgameObject:)
    @NSManaged public func removeFromCdcountriesforgame(_ value: CDCountriesForGame)

    @objc(addCdcountriesforgame:)
    @NSManaged public func addToCdcountriesforgame(_ values: NSSet)

    @objc(removeCdcountriesforgame:)
    @NSManaged public func removeFromCdcountriesforgame(_ values: NSSet)

}
