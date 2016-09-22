//
//  resultInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 22/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

protocol ResultInteractorInterface {
  func saveGameToCoreData(game: Game)
}

class ResultInteractor: ResultInteractorInterface, DataService {
  
  var CDGames = [CDGame]()
  var cdCountriesForGame = [CDCountriesForGame]()
  var _games = [Game]()
  var _countries = [Country]()

  
  func saveNewGame(game: Game) {
    
    let newGame = NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: ad.managedObjectContext) as! CDGame
    
    newGame.attempts = Double(game.attempts)
    newGame.highestPercentage = Double(game.highestPercentage)
    newGame.dateLastCompleted = Date() as NSDate?
    
    for i in game.countries {
      
      let countries = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
      
      countries.cdgame = newGame
      countries.country = i.name
    }
    
    ad.saveContext()
  }
  
  func saveGameToCoreData(game: Game) {
    
    fetch(game: game)
    
    for i in _games {
      
      if i.dateLastCompleted == game.dateLastCompleted {
        
        
      }
    }
   
  }
  
  func fetch(game: Game) {
    
    ad.saveContext()
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    _countries = countryArray
    
    if #available(iOS 10.0, *) {
      
      let request: NSFetchRequest<NSFetchRequestResult> = CDGame.fetchRequest()
      let countriesRequest: NSFetchRequest<NSFetchRequestResult> = CDCountriesForGame.fetchRequest()
      
      do {
        
        self.CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
        self.cdCountriesForGame = try ad.managedObjectContext.fetch(countriesRequest) as! [CDCountriesForGame]
        
        var countryArray = [Country]()
        
        if CDGames.isEmpty {
          saveNewGame(game: game)

          return
        }
        
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

        
        for i in CDGames {
          
          if i.dateLastCompleted == game.dateLastCompleted as NSDate {
            
            i.setValue(Date(), forKey: "dateLastCompleted")
            i.setValue(game.highestPercentage, forKey: "highestPercentage")
            i.setValue(game.attempts, forKey: "attempts")
            
//            ad.saveContext()

            break

          } else {
            
            saveNewGame(game: game)
            break
          }
        }
        

        
        
        
        print(CDGames)
        
      } catch {
        print(error)
        
      }
    }
  }

}
