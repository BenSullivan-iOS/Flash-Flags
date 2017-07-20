//
//  CustomGameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameInteractor: CustomGameInteractorInterface, DataService, CoreDataService {
  
  fileprivate var didUpdateCountries = false
  fileprivate(set) var imageCache = NSCache<NSString, UIImage>()
  fileprivate(set) var filteredCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  fileprivate(set) var remainingCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  fileprivate(set) var chosenCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  var countries: [Country] {
    return remainingCountries
  }
  
  //MARK: - INITIALISER
  
  init(countries: [Country]) {
    
    remainingCountries.removeAll()
    remainingCountries = countries
    
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func setCountries(countryArray: [Country]) {
    remainingCountries = countryArray
  }
  
  internal func saveToCoreData(remainingCountries: [Country]) {
    self.saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
  }
  
  internal func filterCountries(withText text: String) {
    
    filteredCountries.removeAll()
    
    for i in remainingCountries.indices {
      
      if remainingCountries[i].name.lowercased().contains(text.lowercased()) {
        
        filteredCountries.append(remainingCountries[i])
      }
    }
  }
  
  internal func addFlag(country: Country, searchActive: Bool) -> IndexPath? {
      
      for i in chosenCountries.indices {
        
        if chosenCountries[i] == country {
          didUpdateCountries = true
          remainingCountries.insert(country, at: 0)
          chosenCountries.remove(at: i)
          
          if searchActive {
            filteredCountries.insert(country, at: 0)
          }
          
          return IndexPath(row: i, section: 0)
        }
      }
    return nil
  }
  
  internal func removeFlag(country: Country, searchActive: Bool) -> IndexPath? {
    
    if !searchActive {
      
      for i in remainingCountries.indices {
        
        if remainingCountries[i] == country {
          
          didUpdateCountries = true
          remainingCountries.remove(at: i)
          chosenCountries.insert(country, at: 0)
          
          let indexPath = IndexPath(row: i, section: 0)
          
          return indexPath
        }
      }
    } else {
      
      for i in filteredCountries.indices {
        
        if filteredCountries[i] == country {
          
          didUpdateCountries = true
          filteredCountries.remove(at: i)
          chosenCountries.insert(country, at: 0)
          
          let indexPath = IndexPath(row: i, section: 0)
          
          for a in remainingCountries.indices where remainingCountries[a] == country {
            remainingCountries.remove(at: a)
            return indexPath
          }
          
          return indexPath
        }
      }
    }
    return nil
  }
  
}

extension CustomGameInteractor: ImageCacheable {
  
  
  internal func populateCurrentCoutntriesCache(isRemainingCountry: Bool) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.remainingCountries.indices {
        
        if self.didUpdateCountries {
          self.didUpdateCountries = false
          self.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
          return
        }
        
        let isIndexValid = self.remainingCountries.indices.contains(i)
        
        if isIndexValid {
          self.cacheImage(i, width: 200, size: .small)
        }
      }
    }
  }
  
  internal func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        
        let isIndexValid = self.remainingCountries.indices.contains(i.row)
        
        if isIndexValid {
          self.cacheImage(i.row, width: 200, size: .small)
        }
      }
    }
  }
}
