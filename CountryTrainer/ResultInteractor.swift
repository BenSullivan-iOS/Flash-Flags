//
//  resultInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 22/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

class ResultInteractor: ResultInteractorInterface, DataService {
  
  fileprivate var CDGames = [CDGame]()
  fileprivate var cdCountriesForGame = [CDCountriesForGame]()
//  fileprivate var _games = [Game]()
  fileprivate var _countries = [Country]()
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func saveGameToCoreData(game: Game) {
    
    fetch(game: game)
  }
  
  
  //MARK: - PRIVATE FUNCTIONS

  private func fetch(game: Game) {
    
    ad.saveContext()
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    _countries = countryArray
    
    if #available(iOS 10.0, *) {
      
      let request: NSFetchRequest<NSFetchRequestResult> = CDGame.fetchRequest()
      
      do {
        
        self.CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
        
        if CDGames.isEmpty {
          saveNewGame(game: game)

          return
        }
        
        if !updateExistingGameIfExists(game: game) {
          saveNewGame(game: game)
        }
        
        //      let countriesRequest: NSFetchRequest<NSFetchRequestResult> = CDCountriesForGame.fetchRequest()

        //        self.cdCountriesForGame = try ad.managedObjectContext.fetch(countriesRequest) as! [CDCountriesForGame]

        //        var countryArray = [Country]()

        
//        for i in CDGames {
        
//          countryArray.removeAll()
//          
//          let arr = i.cdcountriesforgame?.allObjects
//          
//          for a in arr! where (arr?[0] as! CDCountriesForGame).cdgame == i {
//            
//            for i in _countries {
//              
//              if i.name == (a as! CDCountriesForGame).country! {
//                countryArray.append(i)
//              }
//            }
//            
//          }
          
//          let game = Game(countries: countryArray,
//                          attempts: Int(i.attempts),
//                          dateLastCompleted: i.dateLastCompleted as Date?,
//                          highestPercentage: Int(i.highestPercentage))
//          
//          _games.append(game)
          
//        }
        
      } catch {
        print(error)
        
      }
    }
  }
  
  private func saveNewGame(game: Game) {
    
    let newGame = NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: ad.managedObjectContext) as! CDGame
    
    newGame.attempts = Double(game.attempts)
    newGame.highestPercentage = Double(game.highestPercentage)
    newGame.dateLastCompleted = Date() as NSDate?
    newGame.dateCreated = game.dateCreated as NSDate?
    newGame.customGameTitle = game.customGameTitle
    
    for i in game.countries {
      
      let countries = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
      
      countries.cdgame = newGame
      countries.country = i.name
    }
    
    ad.saveContext()
  }
  
  private func updateExistingGameIfExists(game: Game) -> Bool {
    
    var gameRequiredUpdate = false
    
    for i in CDGames {
      
      if i.dateCreated == game.dateCreated as NSDate {
        
        gameRequiredUpdate = true
        
        i.setValue(Date(), forKey: "dateLastCompleted")
        i.setValue(game.highestPercentage, forKey: "highestPercentage")
        i.setValue(game.attempts, forKey: "attempts")
        
        return gameRequiredUpdate
      }
    }
    return gameRequiredUpdate
  }
}
