//
//  Game.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

extension Game {
  
  static func ==(lhs: Game, rhs: Game) -> Bool {
    
    if lhs._dateCreated == rhs._dateCreated {
      return true
    }
    return false
  }
}

struct Game: GameType {
  
  init(countries: [Country], attempts: Int, dateLastCompleted: Date?, highestPercentage: Int?, dateCreated: Date?) {
    self._countries = countries
    self.tracker = Tracker(countries: countries)
    self._attempts = attempts
    self._highestPercentage = highestPercentage ?? 0
    self._dateLastCompleted = dateLastCompleted ?? Date()
    self._dateCreated = dateCreated ?? Date()
    setUid()
    setDelegate()
  }
  
  mutating func setDelegate() {
    tracker.gameDelegate = self
  }
  
  fileprivate var _countries: [Country]
  fileprivate var _dateLastCompleted: Date
  fileprivate var _attempts: Int
  fileprivate var _highestPercentage: Int
  fileprivate var _dateCreated: Date
  fileprivate var _uid = NSString()
  
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
  
  var dateCreated: Date {
    return _dateCreated
  }
  
  var uid: NSString {
    return _uid
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
  
  mutating func setUid() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yy, H:mm"
    _uid = dateFormatter.string(from: _dateCreated) as NSString
  }
  
  mutating func gameRetried() {
    _dateLastCompleted = Date()
  }
  
  mutating func gameCompleted() {

    _attempts += 1
    _dateLastCompleted = Date()
    
    if _highestPercentage < resultPercentage {
      _highestPercentage = resultPercentage
    }
    
    tracker = Tracker(countries: countries)

  }
}
