//
//  GameTracker.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

struct Tracker: TrackerType {
  
  fileprivate(set) var remainingCountries = [Country]()
  fileprivate(set) var remainingCells = [String : Bool]()
  fileprivate(set) var answers = [String : Bool]()
  
  internal var gameDelegate: GameType?
  
  init(countries: [Country]) {
    
    remainingCountries = countries
    
    remainingCountries.forEach {
      
      answers[$0.name] = false
    }
    
    remainingCells = answers
  }
  
  private mutating func removeRemainingCountry(at index: Int) {
    remainingCountries.remove(at: index)
  }
  
  private mutating func removeRemainingCell(country: String) {
    remainingCells.removeValue(forKey: country)
  }
  
  mutating func updateTracker(_ country: String, result: Bool) {
    
    answers[country] = result
    
    if remainingCountries.count == 1 {
      
      gameDelegate?.gameCompleted()
      print("Game completed")
      
    }
    
    for i in remainingCells where i.0 == country {
      
      _ = removeRemainingCell(country: country)
      
    }
    
    for a in remainingCountries.indices where remainingCountries[a].name == country {
      removeRemainingCountry(at: a)
      break
    }

  }
  
  mutating func shuffleCountries() {
    remainingCountries.shuffle()
  }
}
