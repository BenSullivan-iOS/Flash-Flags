//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainInteractor: MainInteractorInterface, DataService {
  
  internal func populateGames(game: Game) {
    //fixme: delete this
  }
  
  fileprivate var numberOfFlagsSelected = Int()
  fileprivate var chosenOnes = [Country]()
  fileprivate var countries = [Country]()
  fileprivate var newGame: Game? = nil
  
  var mainVCInterface: MainVCInterface?

  
  init() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
  }
  
  
  
  
  func getNewGameData(numberOfFlags: Int, continent: String?) {
    
    clearCurrentGameData()
    
    numberOfFlagsSelected = numberOfFlags
    
    print(continent!, Continent.Africa.rawValue)
    
    var filteredCountries = countries
    
    if continent != nil {
      
      filteredCountries = countries.filter { country -> Bool in
        
        return country.cont.rawValue == continent
      }
      
      filteredCountries.forEach { cont in
        
        print(cont.cont.rawValue)
      }
      print(continent)
    }
    
    var chosenNumbers = Set<Int>()
    
    for _ in 1...numberOfFlagsSelected {
      chosenNumbers.insert(Int(arc4random_uniform(UInt32(filteredCountries.count))))
      
      print(chosenNumbers)
      
    }
    
    for i in chosenNumbers {
      print(filteredCountries)
      
      chosenOnes.append(filteredCountries[i])
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
