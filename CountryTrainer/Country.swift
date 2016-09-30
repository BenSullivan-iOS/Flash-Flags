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
  
  fileprivate let _name: String!
  fileprivate let _currency: String!
  fileprivate let _flag: String!
  fileprivate let _flagSmall: String!
  fileprivate let _cont: Continent
  fileprivate let _difficulty: Difficulty
  
  var name: String! {
    return _name
  }
  var currency: String! {
    return _currency
  }
  var flag: String! {
    return _flag
  }
  var flagSmall : String {
    return _flag + "-1"
  }
  var cont: Continent {
    return _cont
  }
  var difficulty: Difficulty {
    return _difficulty
  }
  
  init(name: String, currency: String, flag: String, continent: Continent, difficulty: Difficulty) {
    self._name = name
    self._currency = currency
    self._flag = flag
    self._cont = continent
    self._flagSmall = _flag + "-1"
    self._difficulty = difficulty
  }

}
