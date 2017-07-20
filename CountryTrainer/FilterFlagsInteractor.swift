//
//  FilterFlagsInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsInteractor: FilterFlagsInteractorInterface, DataService, CoreDataService {
  
  fileprivate var didUpdateCountries = false
  fileprivate(set) var imageCache = NSCache<NSString, UIImage>()
  fileprivate(set) var countries = [Country]()
  
  fileprivate(set) var remainingCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  fileprivate(set) var memorisedCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  
  //MARK: - INITIALISER
  
  init(countries: [Country]) {
    setCountries(countryArray: countries)
    remainingCountries = countries
    setMemorisedCountries()
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func setCountries(countryArray: [Country]) {
    countries = countryArray
  }
  
  internal func saveToCoreData(remainingCountries: [Country]) {
    self.saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
    
  }
  
  internal func addFlag(country: Country) -> IndexPath? {
    
    for i in memorisedCountries.indices {
      
      if memorisedCountries[i] == country {
        didUpdateCountries = true
        countries.remove(at: i)
        remainingCountries.insert(country, at: 0)
        memorisedCountries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
    
  }
  
  internal func removeFlag(country: Country) -> IndexPath? {
    
    for i in countries.indices {
      
      if countries[i] == country {
        
        didUpdateCountries = true
        countries.remove(at: i)
        remainingCountries.remove(at: i)
        memorisedCountries.insert(country, at: 0)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
  }
  
  internal func resetAllFlags() -> Bool {
    
    guard let countryArray = createCountries() else { print("json error"); return false }
    
    countries.removeAll()
    memorisedCountries.removeAll()
    remainingCountries.removeAll()
    
    saveRemainingCountriesToCoreData(remainingCountries: countryArray)
    
    if let remainingCountryNames = fetchRemainingCountries() {
      
      for i in countryArray.indices {
        
        for nameString in remainingCountryNames {
          
          if countryArray[i].name == nameString {
            
            countries.append(countryArray[i])
          }
        }
      }
    }
    
    setCountries(countryArray: countries)
    remainingCountries = countries
    setMemorisedCountries()
    
    return true
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func setMemorisedCountries() {
    
    guard let allCountries = createCountries() else { print("json error"); return }
    
    memorisedCountries = allCountries.filter { c -> Bool in
      
      for i in remainingCountries {
        if c == i {
          return false
        }
      }
      return true
    }
  }
}

extension FilterFlagsInteractor: ImageCacheable {
  
  internal func populateCurrentCountriesCache(isRemainingCountry: FilterSelection) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.countries.indices {
        
        if self.didUpdateCountries {
          self.didUpdateCountries = false
          self.populateCurrentCountriesCache(isRemainingCountry: isRemainingCountry)
          return
        }
        
        if self.countries.indices.contains(i) {
          self.cacheImage(i, width: CGFloat(200), size: .small)
        }
      }
    }
  }
  
  internal func populateCacheFromPrefetch(indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for indexPath in indexPaths where self.countries.indices.contains(indexPath.row) {
        
        self.cacheImage(indexPath.row, width: CGFloat(200), size: .small)
      }
    }
  }
}
