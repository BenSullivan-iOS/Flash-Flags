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
  fileprivate var _games = [Game]()
  
  internal var mainVCInterface: MainVCInterface?
  internal var startNewGameVCInterface: StartNewGameVCInterface?
  
  internal var games: [Game] {
    return _games
  }
  
  internal var countries: [Country] {
    return _countries
  }
  
  
  //MARK: - INITIALISER
  
  override init() {
    super.init()
    
    loadSavedCountriesAndGames()
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  func updateCountries(countries: [Country]) {
    _countries = countries
  }
  
  func getNewGameData(numberOfFlags: Int, continent: String?) {
    //FIXME: - Needs refactoring
    
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
    
    //Change number of flags if countries are filtered to below the selected amount
    if countries.count < numberOfFlags {
      numberOfFlagsSelected = countries.count
    } else {
      numberOfFlagsSelected = numberOfFlags
    }
    
    //Set prevents duplicate flags being selected
    var chosenNumbers = Set<Int>()
    
    
    //Fills chosenNumbers with random numbers
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
  }
  
  
  func prepareContinentsForPicker() -> [String] {
    
    var continents = Continent.all
    continents.sort()
    
    return continents
  }
  
  
  func prepareNumberOfFlagsForPicker() -> [Int] {
    
    var numberOfFlags = [5]
    
    for i in 1...234 {
      numberOfFlags.append(i)
    }
    return numberOfFlags
  }
  
  
  func populateGamesForMainVCTable(game: Game) {
    
    _games.removeAll()
    _games = fetch()!
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
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func loadSavedCountriesAndGames() {
    
    //Downloads all remaining countries from core data and generates countries array
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    //If the core data store is empty, the function will return nil and store all flags to core data
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
    //Populates exising games once countries are populated
    
    _games = fetch()!
  }

  
}
