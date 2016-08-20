//
//  Game.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

struct Game: GameType {
  
  fileprivate var _countries: [Country]
  fileprivate var _tracker = [String : Bool]()
  
  var cellTracker = [String : Bool]()
  
  var tracker: [String : Bool] {
    
    get {
      return _tracker
    }
    set {
      _tracker = newValue
    }
  }
  
  var countries: [Country] {
    return _countries
  }
  
  var numberOfFlags: Int {
    return countries.count
  }
  
  var count = 0
  
  init(countries: [Country]) {
    self._countries = countries
    loadTracker()
    cellTracker = tracker
  }
}
