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

class ResultInteractor: ResultInteractorInterface {
  
  func saveGameToCoreData(game: Game) {
    
    let updateGame = NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: ad.managedObjectContext) as! CDGame

    updateGame.attempts = Double(game.attempts)
    updateGame.highestPercentage = Double(game.highestPercentage)
    updateGame.dateLastCompleted = game.dateLastCompleted as NSDate?
    
    print(game.highestPercentage)
    print(game.resultPercentage)
    

    
    for i in game.countries {
      
      let countries = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
      
      countries.cdgame = updateGame
      countries.country = i.name
    }
    
    ad.saveContext()
  }
}
