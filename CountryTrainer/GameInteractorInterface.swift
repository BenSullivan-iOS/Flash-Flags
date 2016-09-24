//
//  GameInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameInteractorInterface {
  
  var currentGame: Game { get }
  var imageCache: NSCache<NSString, UIImage> { get }
  
  func populateCurrentCoutntriesCache(indexPaths: [IndexPath])
  func populateCache()
  func answered(country: String, result: Bool)
  func retryGame()
  func shuffleCountries()
  func gameCompleted()
}
