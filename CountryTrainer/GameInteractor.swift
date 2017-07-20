//
//  GameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameInteractor: GameInteractorInterface {
  
  fileprivate(set) var currentGame: Game
  fileprivate(set) var imageCache = NSCache<NSString, UIImage>()
  
  var countries: [Country] {
    return currentGame.tracker.remainingCountries
  }
  
  //MARK: - INITIALISER
  
  init(game: Game) {
    currentGame = game
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func answered(country: String, result: Bool) {
    currentGame.tracker.updateTracker(country, result: result)
  }
  
  internal func retryGame() {
    currentGame.gameCompleted()
  }
  
  internal func shuffleCountries() {
    currentGame.tracker.shuffleCountries()
  }
  
  internal func gameCompleted() {
    currentGame.gameCompleted()
  }
  
}

extension GameInteractor: ImageCacheable {
  
  internal func populateCache() {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.currentGame.countries.indices {
        
        let isIndexValid = self.currentGame.countries.indices.contains(i)
        
        if isIndexValid {
          self.cacheImage(i, width: 500, size: .large)
        }
      }
    }
  }
  
  internal func populateCurrentCountriesCacheForPrefetching(indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        
        let isIndexValid = self.currentGame.tracker.remainingCountries.indices.contains(i.row)
        
        if isIndexValid {
          self.cacheImage(i.row, width: 500, size: .large)
        }
      }
    }
  }
}
