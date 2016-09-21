//
//  GameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameInteractor: GameInteractorInterface {
  
  fileprivate var _currentGame: Game!
  
  var currentGame: Game {
    return _currentGame
  }
  fileprivate var _imageCache = NSCache<NSString, UIImage>()
  
  var imageCache: NSCache<NSString, UIImage> {
    return _imageCache
  }
  
  
  init(game: Game) {
    
    _currentGame = game
  }
  func answered(country: String, result: Bool) {
    
    _currentGame.tracker.updateTracker(country, result: result)
    
  }
  
  func populateCache() {
    
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
  
  
  func populateCurrentCoutntriesCache(indexPaths: [IndexPath]) {
    
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
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func retryGame() {
    
    let game = currentGame
    _currentGame = Game(countries: game.countries, attempts: game.attempts)
    _currentGame.gameRetried()
    
    //    return currentGame
  }
  
}
