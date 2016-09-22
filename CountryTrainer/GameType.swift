//
//  GameType.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameType {
  
  var countries: [Country] { get }
  var numberOfFlags: Int { get }
  var tracker: Tracker { get set }
  mutating func setHighestPercentage()
}
