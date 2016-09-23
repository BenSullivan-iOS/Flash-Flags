//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

class MainInteractor: NSObject, MainInteractorInterface, DataService, CoreDataService {
  
  fileprivate var numberOfFlagsSelected = Int()
  fileprivate var chosenOnes = [Country]()
  fileprivate var _countries = [Country]()
  fileprivate var newGame: Game? = nil
  fileprivate var _games = [Game]()
  
  var count = 0

  func retryGame() {
    
    mainVCInterface?.prepareGameData(game: _games[count])
    
    count += 1
  }
  
  func deleteGame(game: Game) {
    
    if deleteGameFromCoreData(game: game) {
      print("Delete success")
      
      for i in _games.indices {
        if _games[i].dateLastCompleted == game.dateLastCompleted {
          _games.remove(at: i)
          mainVCInterface?.reloadTableData()
          break
          
        }
      }
      
    } else {
      print("delete failed")
    }
    
  }
  
  var games: [Game] {
    return _games
  }
  
  var countries: [Country] {
    return _countries
  }
  
  var mainVCInterface: MainVCInterface?
  var startNewGameVCInterface: StartNewGameVCInterface?
  
  override init() {
    super.init()
    
    //    get all countries

    guard let countryArray = createCountries() else { print("json error"); return }
    
//    get array of country names from core data
//    will return nil if

    if let remainingCountryNames = fetchRemainingCountries() {
      
      for i in countryArray.indices {
        
        for nameString in remainingCountryNames {
          
          if countryArray[i].name == nameString {
            
            _countries.append(countryArray[i])
            print(nameString)

          }
        }
        
      }
      
    } else {
      
     let remainingCountryNames = fetchRemainingCountries()
      
      for i in countryArray.indices {
        
        for nameString in remainingCountryNames! {
          
          if countryArray[i].name == nameString {
            
            _countries.append(countryArray[i])
            print(nameString)
          }
        }
        
      }
    }
    
    _games = fetch()!
    
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
      print(numberOfFlagsSelected)
    }
    
    for i in chosenNumbers {
      chosenOnes.append(filteredCountries[i])
    }
    
    let game = Game(countries: chosenOnes, attempts: 0, dateLastCompleted: nil, highestPercentage: nil)
    
    mainVCInterface?.prepareGameData(game: game)
    
    
  }
  
  func clearCurrentGameData() {
    chosenOnes.removeAll()
    newGame = nil
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
    
    for i in 1...234 {
      numberOfFlags.append(i)
    }
    return numberOfFlags
  }
  
  func populateGamesForMainVCTable(game: Game) {
    
    _games.removeAll()
    _games = fetch()!

//    fetch()
  }
  
}
