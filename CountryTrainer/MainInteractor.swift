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
  
  internal func updateCountries(countries: [Country]) {
    _countries = countries
  }
  
  internal func getNewGameData(numberOfFlags: Int, continent: String?, difficulty: String) {
    
    //Filters out countires based on the continent provided
    var filteredCountries = _countries
    
    if continent != nil && continent != Continent.all.rawValue {
      
      filteredCountries = _countries.filter { country -> Bool in
        
        return country.cont.rawValue == continent
      }
    }
    
    if difficulty != Difficulty.allDifficulties.rawValue {
      
      filteredCountries = filteredCountries.filter { country -> Bool in
        
        return country.difficulty.rawValue == difficulty
      }
    }
    
    //Display alert if no flags to display
    
    if filteredCountries.count == 0 {
      startNewGameVCInterface?.displayAlert(title: "WOW!", message: "There are no more remaining flags in \(continent ?? "the list")")
      return
    }
    
    filteredCountries.shuffle()
    
    var filteredArray = [Country]()
    
    for i in 0...numberOfFlags - 1 {
      
      let isIndexAvailable = filteredCountries.indices.contains(i)
      
      if isIndexAvailable {
        filteredArray.append(filteredCountries[i])
      }
      
    }
    
    let game = Game(countries: filteredArray,
                    attempts: 0,
                    dateLastCompleted: nil,
                    highestPercentage: nil,
                    dateCreated: Date())

    mainVCInterface?.prepareGameData(game: game)


  }
  
  internal func prepareContinentsForPicker() -> [String] {
    
    var continents = Continent.allContinents
    continents.sort()
    
    return continents
  }
  
  
  internal func prepareNumberOfFlagsForPicker() -> [Int] {
    
    var numberOfFlags = [5]
    
    for i in 1...234 {
      numberOfFlags.append(i)
    }
    return numberOfFlags
  }
  
  
  
  internal func populateGamesForMainVCTable(game: Game) {
    
    //If game already exists then replace in array, else append
    
    for i in _games.indices {
      
      if _games[i] == game {
        
        _games[i] = game
        return
      }
    }
    
    _games.append(game)
    
  }
  
  internal func deleteGame(game: Game) {
    
    if deleteGameFromCoreData(game: game) {
      print("Delete success")
      
      for i in _games.indices {
        if _games[i].dateCreated == game.dateCreated {
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
          }
        }
        
      }
      
    } else {
      
      let remainingCountryNames = fetchRemainingCountries()
      
      for i in countryArray.indices {
        
        for nameString in remainingCountryNames! {
          
          if countryArray[i].name == nameString {
            
            _countries.append(countryArray[i])
          }
        }
        
      }
    }
    //Populates exising games once countries are populated
    
    _games = fetch()!
  }
  
}
