//
//  Country.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

extension Country {
  
  static func ==(lhs: Country, rhs: Country) -> Bool {
    
    return lhs.cont == rhs.cont && lhs.currency == rhs.currency && lhs.flag == rhs.flag && lhs.name == rhs.name
  }
}

struct Country {
  
  fileprivate(set) var name: String
  fileprivate(set) var currency: String
  fileprivate(set) var flag: String
  fileprivate(set) var flagSmall: String
  fileprivate(set) var cont: Continent
  fileprivate(set) var difficulty: Difficulty
  
  init(name: String, currency: String, flag: String, continent: Continent, difficulty: Difficulty) {
    self.name = name
    self.currency = currency
    self.flag = flag
    self.cont = continent
    self.flagSmall = flag + "-1"
    self.difficulty = difficulty
  }

}
