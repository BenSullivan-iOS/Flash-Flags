//
//  GameTracker.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameTracker {
  
  var remainingCells: [String : Bool] { get }
  var remainingCountries: [Country] { get }
  var answers: [String : Bool] { get }
  init(countries: [Country])

}

struct Tracker: GameTracker {
  
  fileprivate var _remainingCountries = [Country]()
  fileprivate var _remainingCells = [String : Bool]()
  fileprivate var _answers = [String : Bool]()
  
  internal var answers: [String : Bool] {
    return _answers
  }

  internal var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  internal var remainingCells: [String : Bool] {
    return _remainingCells
  }
  
  init(countries: [Country]) {
    
    _remainingCountries = countries
    
    remainingCountries.forEach {
      
      _answers[$0.name] = false
    }
    
    _remainingCells = _answers
  }
  
  private mutating func removeRemainingCountry(at index: Int) {
    _remainingCountries.remove(at: index)
  }
  
  private mutating func removeRemainingCell(country: String) {
    _remainingCells.removeValue(forKey: country)
  }
  
  mutating func updateTracker(_ country: String, result: Bool) {
    
    _answers[country] = result
    
    if remainingCountries.count == 1 {
      
      print("Game completed")
      
    }
    
    for i in remainingCells where i.0 == country {
      
      _ = removeRemainingCell(country: country)
      
      print(remainingCells)
      
    }
    
    for a in remainingCountries.indices where remainingCountries[a].name == country {
      removeRemainingCountry(at: a)
      break
    }

  }
}
