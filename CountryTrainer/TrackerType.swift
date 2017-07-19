//
//  TrackerType.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 19/07/2017.
//  Copyright © 2017 Ben Sullivan. All rights reserved.
//

protocol TrackerType {
  
  var remainingCells: [String : Bool] { get }
  var remainingCountries: [Country] { get }
  var answers: [String : Bool] { get }
  init(countries: [Country])
  
}
