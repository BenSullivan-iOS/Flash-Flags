//
//  FilterFlagsInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsInteractor: FilterFlagsInteractorInterface {
  
  fileprivate var _countries = [Country]()
  fileprivate var _remainingCountries = [Country]()
  fileprivate var _memorisedCountries = [Country]()
  
  var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  var memorisedCountries: [Country] {
    return _memorisedCountries
  }
  
  var countries: [Country] {
    return _countries
  }
  
  init(countries: [Country]) {
    setCountries(countryArray: countries)
    _remainingCountries = countries
  }
  
  func setCountries(countryArray: [Country]) {
    _countries = countryArray
  }
  
  func addFlag(country: Country) -> IndexPath? {
    
    for i in _memorisedCountries.indices {
      
      if _memorisedCountries[i] == country {
        
        _countries.remove(at: i)
        _remainingCountries.insert(country, at: 0)
        _memorisedCountries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil

  }
  
  func removeFlag(country: Country) -> IndexPath? {
    
    for i in _countries.indices {
      
      if _countries[i] == country {
        
        _countries.remove(at: i)
        _remainingCountries.remove(at: i)
        _memorisedCountries.insert(country, at: 0)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
  }
  
}
