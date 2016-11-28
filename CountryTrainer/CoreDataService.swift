//
//  CoreDataService.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 22/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataService: DataService {
  func fetch() -> [Game]?
  func deleteGameFromCoreData(game: Game) -> Bool
  func fetchRemainingCountries() -> [String]?
  func saveRemainingCountriesToCoreData(remainingCountries: [Country])
  func removeRemainingCountriesFromCoreData()
  
}


extension CoreDataService {
  
  func fetch() -> [Game]? {
    
    guard let countryArray = createCountries() else { print("json error"); return nil }
    
    let _countries = countryArray
    var CDGames = [CDGame]()
    var _games = [Game]()
    let request: NSFetchRequest<NSFetchRequestResult>
    
    if #available(iOS 10.0, *) {
      request = CDGame.fetchRequest()
    } else {
      request = NSFetchRequest(entityName: "CDGame")
    }
    ad.saveContext()
    
    
    do {
      
      CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
      
      var countryArray = [Country]()
      
      print("Fetching games")
      
      for i in CDGames {
        dump(i)
        countryArray.removeAll()
        
        let arr = i.cdcountriesforgame?.allObjects
        
        for a in arr! where (arr?[0] as! CDCountriesForGame).cdgame == i {
          
          for i in _countries {
            
            if i.name == (a as! CDCountriesForGame).country! {
              countryArray.append(i)
              
            }
          }
          
        }
        
        let game = Game(countries: countryArray,
                        attempts: Int(i.attempts),
                        dateLastCompleted: i.dateLastCompleted as Date?,
                        highestPercentage: Int(i.highestPercentage),
                        dateCreated: i.dateCreated as Date?,
                        customGameTitle: i.customGameTitle ?? nil,
                        subject: i.subject ?? "flags")
        
        _games.append(game)
      }
      
      return _games
      
      
    } catch {
      
      print(error)
      return nil
      
      
    }
  }
  
  func deleteGameFromCoreData(game: Game) -> Bool {
    
    var CDGames = [CDGame]()
    
    ad.saveContext()
    
    let request: NSFetchRequest<NSFetchRequestResult>
    
    if #available(iOS 10.0, *) {
      request = CDGame.fetchRequest()
    } else {
      request = NSFetchRequest(entityName: "CDGame")
    }
    do {
      
      CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
      
      for i in CDGames {
        
        if i.dateCreated == game.dateCreated as NSDate {
          
          ad.managedObjectContext.delete(i)
          
          ad.saveContext()
          
          return true
        }
      }
      
    } catch {
      
      print(error)
      return false
    }
    return false
  }
  
  
  
  func fetchRemainingCountries() -> [String]? {
    
    let request: NSFetchRequest<NSFetchRequestResult>
    
    var remainingCountries = [String]()
    
    var cdCountriesTracker = [CDCountriesTracker]()
    
    ad.saveContext()
    
    if #available(iOS 10.0, *) {
      
      request = CDCountriesTracker.fetchRequest()
      
      do {
        
        cdCountriesTracker = try ad.managedObjectContext.fetch(request) as! [CDCountriesTracker]
        
        for i in cdCountriesTracker {
          
          remainingCountries.append(i.remaining!)
        }
        
        if cdCountriesTracker.isEmpty {
          
          saveAllCountriesToCoreData()
          
          return nil
        }
        
        return remainingCountries
        
      } catch {
        
        print(error)
        return nil
      }
    } else if #available(iOS 9.3, *) {
      
      request = NSFetchRequest(entityName: "CDCountriesTrackerEntity")
      
      do {
        
        cdCountriesTracker = try ad.managedObjectContext.fetch(request) as! [CDCountriesTracker]
        
        for i in cdCountriesTracker {
          
          remainingCountries.append(i.remaining!)
        }
        
        if cdCountriesTracker.isEmpty {
          
          saveAllCountriesToCoreData()
          
          return nil
        }
        
        return remainingCountries
        
      } catch {
        
        print(error)
        return nil
        
        
      }
    }
    return nil
  }
  
  func saveAllCountriesToCoreData() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    for i in countryArray {
      
      let countries = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesTrackerEntity", into: ad.managedObjectContext) as! CDCountriesTracker
      
      countries.remaining = i.name
    }
    
    ad.saveContext()
    
  }
  
  func removeRemainingCountriesFromCoreData() {
    
    var cdCountriesTracker = [CDCountriesTracker]()
    
    ad.saveContext()
    
    if #available(iOS 10.0, *) {
      
      let request: NSFetchRequest<NSFetchRequestResult> = CDCountriesTracker.fetchRequest()
      
      do {
        
        cdCountriesTracker = try ad.managedObjectContext.fetch(request) as! [CDCountriesTracker]
        
        for i in cdCountriesTracker {
          
          ad.managedObjectContext.delete(i)
          ad.saveContext()
        }
        
      } catch {
        
        print(error)
        
      }
    }
  }
  
  func saveRemainingCountriesToCoreData(remainingCountries: [Country]) {
    
    removeRemainingCountriesFromCoreData()
    
    for i in remainingCountries {
      
      let countries = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesTrackerEntity", into: ad.managedObjectContext) as! CDCountriesTracker
      
      countries.remaining = i.name
      
    }
    ad.saveContext()
  }
}
