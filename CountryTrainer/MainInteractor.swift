//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorInterface, DataService {
  
  fileprivate let numberOfFlagsSelected = 1
  fileprivate var chosenOnes = [Country]()
  fileprivate var countries = [Country]()
  fileprivate var newGame: Game? = nil
  
  init() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
  }

  var mainVCInterface: MainVCInterface?
  
  func getNewGameData() {
    
    clearCurrentGameData()
    
    var chosenNumbers = Set<Int>()
    
    for _ in 1...numberOfFlagsSelected {
      
      chosenNumbers.insert(Int(arc4random_uniform(UInt32(countries.count))))
      
      print(chosenNumbers)
      
    }
    
    for i in chosenNumbers {
      
      chosenOnes.append(countries[i])
      print(chosenOnes)
    }
    
    let game = Game(countries: chosenOnes, attempts: 0)
    
    mainVCInterface?.prepareGameData(game: game)
    
  }
  
  func clearCurrentGameData() {
    chosenOnes.removeAll()
    newGame = nil
    print("Cleared current game data")
  }
}
