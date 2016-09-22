//
//  Game.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

struct Game: GameType {
  
  init(countries: [Country], attempts: Int, dateLastCompleted: Date?, highestPercentage: Int?) {
    self._countries = countries
    self.tracker = Tracker(countries: countries)
    self._attempts = attempts
    self._highestPercentage = highestPercentage ?? 0
    self._dateLastCompleted = dateLastCompleted ?? Date()
    
    setDelegate()
  }
  
  mutating func setDelegate() {
    tracker.gameDelegate = self
  }
  
  fileprivate var _countries: [Country]
  fileprivate var _dateLastCompleted: Date
  fileprivate var _attempts: Int
  fileprivate var _highestPercentage: Int
  
  var tracker: Tracker 
  
  var countries: [Country] {
    return _countries
  }
  
  var numberOfFlags: Int {
    return countries.count
  }
  
  var dateLastCompleted: Date {
    return _dateLastCompleted
  }
  
  var attempts: Int {
    return _attempts
  }
  
  var highestPercentage: Int {
    return _highestPercentage
  }
  
  var progress: String {
    
    var score = 0
    
    for i in self.tracker.answers where i.value == true {
      score += 1
    }
    
    return "\(score)/\(_countries.count)"
  }
  
  var resultPercentage: Int {
    
    var correct = 0.0
    let totalFlags = Double(_countries.count)
    
    for i in self.tracker.answers where i.value == true {
      correct += 1
    }
    
    return Int(correct / totalFlags * 100)
  }
  
  mutating func gameRetried() {
    _dateLastCompleted = Date()
    _attempts += 1
  }
  //Change to complete game
  mutating func setHighestPercentage() {

    if _highestPercentage < resultPercentage {
      _highestPercentage = resultPercentage
    }
  }
}
