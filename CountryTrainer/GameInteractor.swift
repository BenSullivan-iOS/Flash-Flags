//
//  GameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameInteractor: GameInteractorInterface {
  
  var currentGame: Game?
  
  func answered(game: Game, country: String, result: Bool) -> Game {
    
    currentGame = game
    
    currentGame?.tracker.updateTracker(country, result: result)
    
    return currentGame!
    
  }
  
  func retryGame() -> Game {
    
    let game = currentGame!
    
    currentGame = Game(countries: game.countries, attempts: game.attempts)
    
    currentGame?.gameRetried()
    
    return currentGame!
  }
  
}
