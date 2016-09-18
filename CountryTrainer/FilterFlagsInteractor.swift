//
//  FilterFlagsInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

protocol FilterFlagsInteractorInterface {
  func removeFlag(country: Country) -> IndexPath?
  var countries: [Country] { get }
}

class FilterFlagsInteractor: FilterFlagsInteractorInterface {
  
  fileprivate var _countries = [Country]()
  
  var countries: [Country] {
    return _countries
  }
  
  func setCountries(countryArray: [Country]) {
    _countries = countryArray
  }
  
  func removeFlag(country: Country) -> IndexPath? {
    
    for i in _countries.indices {
      
      if _countries[i] == country {
        
        _countries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
  }
  
}
