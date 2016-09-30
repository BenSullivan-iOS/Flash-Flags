//
//  Continent.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

enum Continent: String {
  
  case oceania = "Oceania"
  case africa = "Africa"
  case asia = "Asia"
  case americas = "Americas"
  case europe = "Europe"
  case all = "All Continents"
  
  static let allContinents = [
    oceania.rawValue,
    africa.rawValue,
    asia.rawValue,
    americas.rawValue,
    europe.rawValue]
}
