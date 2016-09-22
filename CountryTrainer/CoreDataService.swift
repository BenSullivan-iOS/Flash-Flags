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
}


extension CoreDataService {
  
  func fetch() -> [Game]? {
    
    guard let countryArray = createCountries() else { print("json error"); return nil }
    
    let _countries = countryArray
    var CDGames = [CDGame]()
    var _games = [Game]()
    
    ad.saveContext()
    
    if #available(iOS 10.0, *) {
      
      let request: NSFetchRequest<NSFetchRequestResult> = CDGame.fetchRequest()
      
      do {
        
        CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
        
        var countryArray = [Country]()
        
        for i in CDGames {
          
          countryArray.removeAll()
          
          print(i.cdcountriesforgame)
          
          let arr = i.cdcountriesforgame?.allObjects
          
          for a in arr! where (arr?[0] as! CDCountriesForGame).cdgame == i {
            
            print((a as! CDCountriesForGame).country)
            
            for i in _countries {
              
              if i.name == (a as! CDCountriesForGame).country! {
                countryArray.append(i)
                print(countryArray)
                
              }
            }
            
          }
          
          let game = Game(countries: countryArray,
                          attempts: Int(i.attempts),
                          dateLastCompleted: i.dateLastCompleted as Date?,
                          highestPercentage: Int(i.highestPercentage))
          
          _games.append(game)
          
          
        }
        
        return _games
        
        
      } catch {
        
        print(error)
        return nil
        
        
      }
    }
    return nil
  }
  
}
