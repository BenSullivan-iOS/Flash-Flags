//
//  Country.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

struct Country {
  
  fileprivate let _name: String!
  fileprivate let _currency: String!
  fileprivate let _flag: String!
  fileprivate let _cont: Continent
  
  var name: String! {
    return _name
  }
  var currency: String! {
    return _currency
  }
  var flag: String! {
    return _flag
  }
  var cont: Continent {
    return _cont
  }
  
  init(name: String, currency: String, flag: String, continent: Continent) {
    self._name = name
    self._currency = currency
    self._flag = flag
    self._cont = continent
  }

}
