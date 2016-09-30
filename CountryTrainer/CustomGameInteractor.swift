//
//  CustomGameInteractor.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameInteractor: CustomGameInteractorInterface, DataService, CoreDataService, ImageResizeable {
  
  fileprivate var didUpdateCountries = false
  fileprivate var _imageCache = NSCache<NSString, UIImage>()
  fileprivate var _countries = [Country]()
  
  fileprivate var _remainingCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  fileprivate var _memorisedCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  var imageCache: NSCache<NSString, UIImage> {
    return _imageCache
  }
  
  var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  var memorisedCountries: [Country] {
    return _memorisedCountries
  }
  
  var countries: [Country] {
    return _countries
  }
  
  
  //MARK: - INITIALISER
  
  init(countries: [Country]) {
    setCountries(countryArray: countries)
    _remainingCountries = countries
    setMemorisedCountries()
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func setCountries(countryArray: [Country]) {
    _countries = countryArray
  }
  
  internal func saveToCoreData(remainingCountries: [Country]) {
    self.saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
    
  }
  
  internal func addFlag(country: Country) -> IndexPath? {
    
    for i in _memorisedCountries.indices {
      
      if _memorisedCountries[i] == country {
        didUpdateCountries = true
        _countries.remove(at: i)
        _remainingCountries.insert(country, at: 0)
        _memorisedCountries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
    
  }
  
  internal func removeFlag(country: Country) -> IndexPath? {
    
    for i in _countries.indices {
      
      if _countries[i] == country {
        
        didUpdateCountries = true
        _countries.remove(at: i)
        _remainingCountries.remove(at: i)
        _memorisedCountries.insert(country, at: 0)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
  }
  
  internal func resetAllFlags() -> Bool {
    
    guard let countryArray = createCountries() else { print("json error"); return false }
    
    _countries.removeAll()
    _memorisedCountries.removeAll()
    _remainingCountries.removeAll()
    
    saveRemainingCountriesToCoreData(remainingCountries: countryArray)
    
    if let remainingCountryNames = fetchRemainingCountries() {
      
      for i in countryArray.indices {
        
        for nameString in remainingCountryNames {
          
          if countryArray[i].name == nameString {
            
            _countries.append(countryArray[i])
          }
        }
      }
    }
    
    setCountries(countryArray: countries)
    _remainingCountries = countries
    setMemorisedCountries()
    
    return true
  }
  
  internal func populateCurrentCoutntriesCache(isRemainingCountry: Bool) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.countries.indices {
        
        if self.didUpdateCountries {
          self.didUpdateCountries = false
          self.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
          return
        }
        
        let isIndexValid = self._countries.indices.contains(i)
        
        if isIndexValid {
          
          let flag = self._countries[i].flag as! NSString
          
          if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
            
            var image = UIImage()
            var imageStr = String()
            
            if isRemainingCountry {
              
              imageStr = self._countries[i].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._countries[i].flag)!
              
            } else {
              
              imageStr = self._countries[i].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._countries[i].flag)!
            }
            
            let smallImage = self.resizeImage(image: image, newWidth: 200)
            self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          }
        }
      }
    }
  }
  
  internal func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        
        let isIndexValid = self._countries.indices.contains(i.row)
        
        if isIndexValid {
          
          
          let flag = self._countries[i.row].flag as! NSString
          
          if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
            
            var image = UIImage()
            var imageStr = String()
            
            if isRemainingCountry {
              
              imageStr = self._countries[i.row].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._countries[i.row].flag)!
              
            } else {
              
              imageStr = self._countries[i.row].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._countries[i.row].flag)!
            }
            
            let smallImage = self.resizeImage(image: image, newWidth: 200)
            self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          }
        }
      }
    }
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func setMemorisedCountries() {
    
    guard let allCountries = createCountries() else { print("json error"); return }
    
    _memorisedCountries = allCountries.filter { c -> Bool in
      
      for i in _remainingCountries {
        if c == i {
          return false
        }
      }
      return true
    }
  }
  
}
