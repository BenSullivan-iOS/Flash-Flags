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
    
    if lhs.dateCreated == rhs.dateCreated {
      return true
    }
    return false
  }
}

struct Game: GameType {
  
  fileprivate(set) var countries: [Country]
  fileprivate(set) var dateLastCompleted: Date
  fileprivate(set) var attempts: Int
  fileprivate(set) var highestPercentage: Int
  fileprivate(set) var dateCreated: Date
  fileprivate(set) var uid = NSString()
  fileprivate(set) var resultFraction: String!
  fileprivate(set) var customGameTitle: String?
  
  var tracker: Tracker
  
  var numberOfFlags: Int {
    return countries.count
  }
  
  var progress: String {
    
    var score = 0
    
    for i in self.tracker.answers where i.value == true {
      score += 1
    }
    
    return "\(score)/\(countries.count)"
  }
  
  var resultPercentage: Int {
    
    var correct = 0.0
    let totalFlags = Double(countries.count)
    
    for i in self.tracker.answers where i.value == true {
      correct += 1
    }
    
    return Int(correct / totalFlags * 100)
  }
  
  init(countries: [Country], attempts: Int, dateLastCompleted: Date?, highestPercentage: Int?, dateCreated: Date?, customGameTitle: String?) {
    self.countries = countries
    self.tracker = Tracker(countries: countries)
    self.attempts = attempts
    self.highestPercentage = highestPercentage ?? 0
    self.dateLastCompleted = dateLastCompleted ?? Date()
    self.dateCreated = dateCreated ?? Date()
    self.customGameTitle = customGameTitle
    setUid()
    setDelegate()
  }
  
  mutating func setDelegate() {
    tracker.gameDelegate = self
  }
  
  mutating func setUid() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yy, H:mm"
    uid = dateFormatter.string(from: dateCreated) as NSString
  }
  
  mutating func gameRetried() {
    dateLastCompleted = Date()
  }
  
  mutating func gameCompleted() {
    
    var correct = 0
    let totalFlags = countries.count
    
    for i in self.tracker.answers where i.value == true {
      correct += 1
    }
    
    resultFraction = "\(correct)/\(totalFlags)"
    
    attempts += 1
    dateLastCompleted = Date()
    
    if highestPercentage < resultPercentage {
      highestPercentage = resultPercentage
    }
    
    tracker = Tracker(countries: countries)

  }
}
