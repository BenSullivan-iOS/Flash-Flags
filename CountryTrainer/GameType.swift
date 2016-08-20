//
//  GameType.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameType {
  
  var countries: [Country] { get }
  var tracker: [String: Bool] { get set }
  var numberOfFlags: Int { get }
  var count: Int { get set }
  mutating func loadTracker()
  mutating func updateTracker(_ country: String, result: Bool)
  
}

extension GameType {
  
  mutating func loadTracker() {
    
    countries.forEach {
      
      tracker[$0.name] = false
    }
  }
  
  mutating func updateTracker(_ country: String, result: Bool) {
    
    if count == countries.count {
      print(count)
      print(tracker)
      print(numberOfFlags)
      print("Game completed")
      
    } else {
      
      count += 1
      
      tracker[country] = result
      
      print(tracker)
    }
  }
}
