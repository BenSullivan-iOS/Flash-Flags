//
//  MainInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

class MainInteractor: NSObject, MainInteractorInterface, DataService {
  
  fileprivate var numberOfFlagsSelected = Int()
  fileprivate var chosenOnes = [Country]()
  fileprivate var _countries = [Country]()
  fileprivate var newGame: Game? = nil
  fileprivate var _games = [Game]()
  
  var CDGames = [CDGame]()
  var cdCountriesForGame = [CDCountriesForGame]()
  
  var count = 0
  
  func retryGame() {
    
    mainVCInterface?.prepareGameData(game: _games[count])
    
    count += 1
  }
  
  func fetch() {
    
    if #available(iOS 10.0, *) {
      
      let request: NSFetchRequest<NSFetchRequestResult> = CDGame.fetchRequest()
      let countriesRequest: NSFetchRequest<NSFetchRequestResult> = CDCountriesForGame.fetchRequest()
      
      do {
        
        self.CDGames = try ad.managedObjectContext.fetch(request) as! [CDGame]
        self.cdCountriesForGame = try ad.managedObjectContext.fetch(countriesRequest) as! [CDCountriesForGame]
        
        var countryArray = [Country]()
        
        for i in CDGames {
          
          countryArray.removeAll()
          
          print(i.cdcountriesforgame)
          
          let arr = i.cdcountriesforgame?.allObjects
          
          for a in arr! where (arr?[0] as! CDCountriesForGame).cdgame == i {
            
            print((a as! CDCountriesForGame).country)
            
            for i in _countries {
              
              if i.name == (a as! CDCountriesForGame).country! {
                countryArray.append(i)
                print(countryArray)
                
              }
            }
            
          }
          
          let game = Game(countries: countryArray,
                          attempts: Int(i.attempts),
                          dateLastCompleted: i.dateLastCompleted as Date?,
                          highestPercentage: Int(i.highestPercentage))
          _games.append(game)
          
        }
        
        print(CDGames)
        
      } catch {
        print(error)
        
      }
    }
  }
  
  
  
  func generateTestData() {
    
    
    
    
    //    let cdGame = NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: ad.managedObjectContext) as! CDGame
    //
    //    cdGame.attempts = 60
    //    cdGame.highestPercentage = 25
    //    cdGame.dateLastCompleted = NSDate()
    //
    //    let country = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
    //
    //    country.cdgame = cdGame
    //    country.country = "Cuba"
    //
    //    let country2 = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
    //
    //    country2.cdgame = cdGame
    //    country2.country = "Norway"
    //
    //
    
    
    //
    //
    //    let cdGame2 = NSEntityDescription.insertNewObject(forEntityName: "CDGame", into: ad.managedObjectContext) as! CDGame
    //
    //    cdGame2.attempts = 70
    //    cdGame2.highestPercentage = 10
    ////    cdGame2.country = "France"
    //    cdGame2.dateLastCompleted = NSDate()
    //
    //    let country3 = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
    //
    //    country3.cdgame = cdGame2
    //    country3.country = "France"
    //
    //    let country4 = NSEntityDescription.insertNewObject(forEntityName: "CDCountriesForGame", into: ad.managedObjectContext) as! CDCountriesForGame
    //
    //    country4.cdgame = cdGame2
    //    country4.country = "Germany"
    
    
    mainVCInterface?.reloadTableData()
    
    ad.saveContext()
    
    //    fetchCountries()
    fetch()
    //    cdGame.cdcountriesforgame = countries
    
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
    
    
    //    fetch()
    guard let countryArray = createCountries() else { print("json error"); return }
    
    _countries = countryArray
    generateTestData()
    
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
    
    for i in 1...236 {
      numberOfFlags.append(i)
    }
    return numberOfFlags
  }
  
  func populateGamesForMainVCTable(game: Game) {
    
    _games.removeAll()
    
    fetch()
    
    //    _games.append(game)
    
  }
  
}
