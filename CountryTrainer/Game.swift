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
    
    for i in self.tracker.answers where i.value == true {
      score += 1
    }
    
    return "\(score)/\(_countries.count)"
  }
  
  var resultPercentage: Int {
    
    var correct = 0.0
    var totalFlags = Double(_countries.count)
    
    for i in self.tracker.answers where i.value == true {
      correct += 1
    }
    
    let diff = totalFlags - correct
    
    print(diff)
    print(totalFlags)
    print(correct)
    print(correct / totalFlags * 100)
        
    return Int(correct / totalFlags * 100)
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
  }
}
