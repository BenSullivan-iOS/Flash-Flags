//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainInteractor: MainInteractorInterface, DataService {
  
  fileprivate var numberOfFlagsSelected = Int()
  fileprivate var chosenOnes = [Country]()
  fileprivate var _countries = [Country]()
  fileprivate var newGame: Game? = nil
  
  var countries: [Country] {
    return _countries
  }
  
  var mainVCInterface: MainVCInterface?
  
  init() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    _countries = countryArray
    
  }
  
  func updateCountries(countries: [Country]) {
    _countries = countries
  }
  
  func getNewGameData(numberOfFlags: Int, continent: String?) {
    
    print(numberOfFlags, continent)
    
    clearCurrentGameData()
    
    numberOfFlagsSelected = numberOfFlags
    
    //Filters out countires based on the continent provided
    var filteredCountries = _countries
    
    if continent != nil && continent != "All" && continent != "Select Continent" {
      
      filteredCountries = _countries.filter { country -> Bool in
        
        return country.cont.rawValue == continent
      }
    }
    
    //Set prevents duplicate flags being selected
    var chosenNumbers = Set<Int>()
    
    while chosenNumbers.count < numberOfFlagsSelected {
      
      chosenNumbers.insert(Int(arc4random_uniform(UInt32(filteredCountries.count))))
    }
    
    for i in chosenNumbers {
      chosenOnes.append(filteredCountries[i])
    }
    
    let game = Game(countries: chosenOnes, attempts: 0)
    
    mainVCInterface?.prepareGameData(game: game)
    
  }
  
  func clearCurrentGameData() {
    chosenOnes.removeAll()
    newGame = nil
    print("Cleared current game data")
  }
  
  func prepareContinentsForPicker() -> [String] {
    var continents = [String]()
    
    continents = Continent.all
    
    continents.sort()

    return continents
    
  }
  
  func prepareNumberOfFlagsForPicker() -> [Int] {
    
    var numberOfFlags = [Int]()
    
    numberOfFlags.append(5)
    
    for i in 1...236 {
      numberOfFlags.append(i)
    }
    return numberOfFlags
  }
}
