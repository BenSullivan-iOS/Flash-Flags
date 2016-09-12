//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorInterface, DataService {
  
  let numberOfFlagsSelected = 5
  var chosenOnes = [Country]()
  var countries = [Country]()
  var newGame: Game? = nil
  
  init() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
  }

  var mainVCInterface: MainVCInterface?
  
  func getNewGameData() {
    print(countries.count)
    
    var chosenNumbers = Set<Int>()
    
    for _ in 1...numberOfFlagsSelected {
      
      chosenNumbers.insert(Int(arc4random_uniform(UInt32(countries.count))))
      
      print(chosenNumbers)
      
    }
    
    for i in chosenNumbers {
      
      chosenOnes.append(countries[i])
      print(countries[i])
    }
    
    let game = Game(countries: chosenOnes)
    
    mainVCInterface?.prepareGameData(game: game)
    
  }
  
  func clearCurrentGameData() {
    print("Cleared current game data")
  }
  
  
  
}
