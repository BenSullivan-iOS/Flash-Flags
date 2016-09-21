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
  var startNewGameVCInterface: StartNewGameVCInterface?
  
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
    

    
    
    //Filters out countires based on the continent provided
    var filteredCountries = _countries
    
    if continent != nil && continent != "All" && continent != "Select Continent" {
      
      filteredCountries = _countries.filter { country -> Bool in
        
        return country.cont.rawValue == continent
      }
    }
    
    if filteredCountries.count == 0 {
      startNewGameVCInterface?.displayAlert(title: "WOW!", message: "There are no more remaining flags in \(continent!)")
      return
    }
    
    //If countries are filtered
    if countries.count < numberOfFlags {
      print(countries.count)
      
      numberOfFlagsSelected = countries.count
    } else {
      numberOfFlagsSelected = numberOfFlags
    }
    
    //Set prevents duplicate flags being selected
    var chosenNumbers = Set<Int>()
    
    while chosenNumbers.count < numberOfFlagsSelected {
      
      chosenNumbers.insert(Int(arc4random_uniform(UInt32(filteredCountries.count))))
      print("chosen numbers", chosenNumbers, chosenNumbers.count)
      print(numberOfFlagsSelected)
    }
    
    for i in chosenNumbers {
      chosenOnes.append(filteredCountries[i])
      print("i = ",i)
    }
    
    let game = Game(countries: chosenOnes, attempts: 0)
    
    mainVCInterface?.prepareGameData(game: game)
    print(game)
    print(chosenNumbers)
    print(filteredCountries)
    
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
