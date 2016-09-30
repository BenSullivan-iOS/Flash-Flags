//
//  MainInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

protocol MainInteractorInterface: class {
  
  var countries: [Country] { get }
  var games: [Game] { get }
  
  func getNewGameData(numberOfFlags: Int, continent: String?, difficulty: String)
  func updateCountries(countries: [Country])
  
  func prepareContinentsForPicker() -> [String]
  func prepareNumberOfFlagsForPicker() -> [Int]
  
  func populateGamesForMainVCTable(game: Game)
  func deleteGame(game: Game)
  
}
