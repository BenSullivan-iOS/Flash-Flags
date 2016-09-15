//
//  GameInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameInteractorInterface {
  func answered(game: Game, country: String, result: Bool) -> Game
  func retryGame() -> Game
  func getCurrentGame() -> Game
}
