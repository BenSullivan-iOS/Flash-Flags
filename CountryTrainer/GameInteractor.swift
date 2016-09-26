//
//  GameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameInteractor: GameInteractorInterface, ImageResizeable {
  
  fileprivate var _currentGame: Game!
  fileprivate var _imageCache = NSCache<NSString, UIImage>()

  internal var currentGame: Game {
    return _currentGame
  }
  
  internal var imageCache: NSCache<NSString, UIImage> {
    return _imageCache
  }
  
  
  //MARK: - INITIALISER
  
  init(game: Game) {
    _currentGame = game
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func answered(country: String, result: Bool) {
    _currentGame.tracker.updateTracker(country, result: result)
  }
  
  internal func populateCache() {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.currentGame.countries.indices {
        
        let flag = self.currentGame.countries[i].flag as! NSString
        
        if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
          
          let imageStr = self.currentGame.countries[i].flagSmall
          
          if let image = UIImage(named: imageStr) ?? UIImage(named: self.currentGame.countries[i].flag) {
            
            let smallImage = self.resizeImage(image: image, newWidth: 200)
            self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          }
          
        }
      }
    }
  }
  
  internal func populateCurrentCoutntriesCache(indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      
      for i in indexPaths {
        
        let flag = self.currentGame.tracker.remainingCountries[i.row].flag as! NSString
        
        if self.imageCache.object(forKey: flag) == nil {
          
          let imageStr = self.currentGame.tracker.remainingCountries[i.row].flag
          
          let image = UIImage(named: imageStr!)
          let smallImage = self.resizeImage(image: image!, newWidth: 500)
          
          self.imageCache.setObject(smallImage, forKey: imageStr! as NSString)
          
        }
      }
    }
  }
  
  internal func retryGame() {
    
//    let game = currentGame
//    _currentGame = Game(countries: game.countries,
//                        attempts: game.attempts,
//                        dateLastCompleted: nil,
//                        highestPercentage: nil)
//    _currentGame.gameRetried()
    
    _currentGame.gameCompleted()
  }
  
  internal func shuffleCountries() {
    _currentGame.tracker.shuffleCountries()
  }
  
  internal func gameCompleted() {
    _currentGame.gameCompleted()
  }
  
}
