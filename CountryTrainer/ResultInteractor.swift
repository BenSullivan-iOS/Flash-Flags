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
  fileprivate(set) var countries = [Country]()
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func saveGameToCoreData(game: Game) {
    
    ad.saveContext()
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
    
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
        
      } catch {
        print(error)
        
      }
    }
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
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
