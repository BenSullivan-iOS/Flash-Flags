//
//  Game.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

struct Game: GameType {
  
  fileprivate var _countries: [Country]
  
  var progress: String {

    var score = 0
    
    for i in self.tracker.answerTracker where i.value == true {
      score += 1
    }
    
    return "\(score)/\(_countries.count)"
  }
  
  var tracker: Tracker
  
  var countries: [Country] {
    return _countries
  }
  
  var numberOfFlags: Int {
    return countries.count
  }
  
  init(countries: [Country]) {
    self._countries = countries
    self.tracker = Tracker(countries: countries)
//    self.score = 0
  }
}
