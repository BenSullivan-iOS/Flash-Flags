//
//  MainInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

protocol MainInteractorInterface {
  
  func clearCurrentGameData()
  func getNewGameData(numberOfFlags: Int, continent: String?)
  func updateCountries(countries: [Country])
  
  var countries: [Country] { get }
  
  func prepareContinentsForPicker() -> [String]
  func prepareNumberOfFlagsForPicker() -> [Int]
  
  func populateGamesForMainVCTable(game: Game)
  var games: [Game] { get }
  
  func retryGame()
  
}
