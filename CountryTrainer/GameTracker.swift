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
  var answerTracker: [String : Bool] { get set }
  var _answers: [String : Bool] { get set }
}

extension GameTracker {
  
  mutating func loadTracker() {
    
    remainingCountries.forEach {
      
      _answers[$0.name] = false
    }
  }
}

struct Tracker: GameTracker {
  
  fileprivate var _remainingCountries = [Country]()
  fileprivate var _remainingCells = [String : Bool]()

  internal var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  internal var remainingCells: [String : Bool] {
    return _remainingCells
  }
  internal var _answers = [String : Bool]()
  
  init(countries: [Country]) {
    
    _remainingCountries = countries
    _remainingCells = answerTracker
    loadTracker()
    
  }
  
  mutating func removeRemainingCountry(at index: Int) {
    _remainingCountries.remove(at: index)
  }
  mutating func removeRemainingCell(country: String) {
    _remainingCells.removeValue(forKey: country)
  }
  
  var answerTracker: [String : Bool] {
    
    get {
      return _answers
    }
    set {
      _answers = newValue
    }
  }
  
  mutating func updateTracker(_ country: String, result: Bool) {
    
    answerTracker[country] = result
    
    if remainingCountries.count == 1 {
      
      print("Game completed")
      
    }
  }
}
