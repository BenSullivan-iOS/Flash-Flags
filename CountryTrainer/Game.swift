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

enum Subject: String {
  case flags
  case capitals
}

struct Game: GameType {
  
  init(countries: [Country], attempts: Int, dateLastCompleted: Date?, highestPercentage: Int?, dateCreated: Date?, customGameTitle: String?, subject: String) {
    self._countries = countries
    self.tracker = Tracker(countries: countries)
    self._attempts = attempts
    self._highestPercentage = highestPercentage ?? 0
    self._dateLastCompleted = dateLastCompleted ?? Date()
    self._dateCreated = dateCreated ?? Date()
    self._customGameTitle = customGameTitle
    self._subject = subject == "flags" ? Subject.flags : Subject.capitals
    self._daysSinceLastCompletedString = String(_dateLastCompleted.daysBetweenDates())
    self._attemptsString = String(attempts)
    self._highestPercentageString = "\(highestPercentage)%"
    self._numberOfFlagsString = "\(countries.count)"
    self._daysAgoString = Int(_daysSinceLastCompletedString) == 1 ? "DAY AGO" : "DAYS AGO"
    self._gameText = countries.count == 1 ? "FLAG" : "FLAGS"
    self._attemptsText = attempts == 1 ? "ATTEMPT" : "ATTEMPTS"
    
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
  fileprivate var _resultFraction: String!
  fileprivate var _customGameTitle: String?
  fileprivate var _subject: Subject
  fileprivate var _daysSinceLastCompletedString: String
  fileprivate var _attemptsString: String
  fileprivate var _highestPercentageString: String
  fileprivate var _numberOfFlagsString: String
  fileprivate var _daysAgoString: String
  fileprivate var _gameText: String
  fileprivate var _attemptsText: String

  var tracker: Tracker
  
  var countries: [Country] {
    return _countries
  }
  
  var numberOfFlags: Int {
    
    get {
      return countries.count
    }
    
    set {
      _numberOfFlagsString = String(newValue)
      
      if subject == .flags {
        _gameText = newValue == 1 ? "FLAG" : "FLAGS"
      } else {
        _gameText = newValue == 1 ? "CAPITAL" : "CAPITALS"
      }
    }
  }
  
  var numberOfFlagsString: String {
    return _numberOfFlagsString
  }
  
  var dateLastCompleted: Date {
    
    get {
      return _dateLastCompleted
    }
    
    set {
      _daysSinceLastCompletedString = String(newValue.daysBetweenDates())
    }
  }
  
  var attempts: Int {
    get {
      return _attempts
    }
    set {
      _attemptsString = String(newValue)
      _attemptsText = newValue == 1 ? "ATTEMPT" : "ATTEMPTS"
    }
  }
  
  var attemptsString: String {
    return _attemptsString
  }
  
  var attemptsText: String {
    return _attemptsText
  }
  
  var highestPercentage: Int {
    
    get {
      return _highestPercentage
    }
    set {
      _highestPercentageString = "\(newValue)%"
    }
  }
  
  var highestPercentageString: String {
    return _highestPercentageString
  }
  
  var dateCreated: Date {
    return _dateCreated
  }
  
  var uid: NSString {
    return _uid
  }
  
  var customGameTitle: String? {
    return _customGameTitle
  }
  
  var subject: Subject {
    return _subject
  }
  
  var daysSinceLastCompletedString: String {
    get {
    return _daysSinceLastCompletedString
    }
    set {
      _daysAgoString = Int(newValue) == 1 ? "DAY AGO" : "DAYS AGO"
    }
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
  
  var resultFraction: String {
    return _resultFraction
  }
  
  var daysAgoString: String {
    return _daysAgoString
  }
  
  var gameText: String {
    return _gameText
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
    
    var correct = 0
    let totalFlags = _countries.count
    
    for i in self.tracker.answers where i.value == true {
      correct += 1
    }
    
    _resultFraction = "\(correct)/\(totalFlags)"
    
    _attempts += 1
    _dateLastCompleted = Date()
    
    if _highestPercentage < resultPercentage {
      _highestPercentage = resultPercentage
    }
    
    tracker = Tracker(countries: countries)

  }
}
