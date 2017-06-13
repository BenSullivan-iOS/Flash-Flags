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
  fileprivate var _filteredCountries = [Country]()

  fileprivate var _remainingCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  fileprivate var _chosenCountries = [Country]() {
    didSet {
      didUpdateCountries = true
    }
  }
  
  internal var imageCache: NSCache<NSString, UIImage> {
    return _imageCache
  }
  
  internal var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  internal var chosenCountries: [Country] {
    return _chosenCountries
  }
  
  internal var filteredCountries: [Country] {
    return _filteredCountries
  }
  
  
  //MARK: - INITIALISER
  
  init(countries: [Country]) {
    
    _remainingCountries.removeAll()
    _remainingCountries = countries
    
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func setCountries(countryArray: [Country]) {
    _remainingCountries = countryArray
  }
  
  internal func saveToCoreData(remainingCountries: [Country]) {
    self.saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
  }
  
  internal func filterCountries(withText text: String) {
    
    _filteredCountries.removeAll()
    
    for i in _remainingCountries.indices {
      
      if _remainingCountries[i].name.lowercased().contains(text.lowercased()) {
        
        _filteredCountries.append(_remainingCountries[i])
      }
    }
  }
  
  internal func addFlag(country: Country, searchActive: Bool) -> IndexPath? {
    
    if !searchActive {
    
    for i in _chosenCountries.indices {
      
      if _chosenCountries[i] == country {
        didUpdateCountries = true
        _remainingCountries.insert(country, at: 0)
        _chosenCountries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    } else {
      
      for i in _chosenCountries.indices {
        
        if _chosenCountries[i] == country {
          didUpdateCountries = true
          _remainingCountries.insert(country, at: 0)
          _filteredCountries.insert(country, at: 0)
          _chosenCountries.remove(at: i)
          
          let indexPath = IndexPath(row: i, section: 0)
          
          return indexPath
        }
      }
      
      
    }
    return nil
    
  }
  
  internal func removeFlag(country: Country, searchActive: Bool) -> IndexPath? {
    
    if !searchActive {
      
      for i in _remainingCountries.indices {
        
        if _remainingCountries[i] == country {
          
          didUpdateCountries = true
          _remainingCountries.remove(at: i)
          _chosenCountries.insert(country, at: 0)
          
          let indexPath = IndexPath(row: i, section: 0)
          
          return indexPath
        }
      }
    } else {
      
      for i in _filteredCountries.indices {
        
        if _filteredCountries[i] == country {
          
          didUpdateCountries = true
          _filteredCountries.remove(at: i)
          _chosenCountries.insert(country, at: 0)
          
          let indexPath = IndexPath(row: i, section: 0)
          
          for a in _remainingCountries.indices where _remainingCountries[a] == country {
            _remainingCountries.remove(at: a)
            return indexPath
          }
          
          return indexPath
        }
      }
    }
    return nil
  }
  
  internal func populateCurrentCoutntriesCache(isRemainingCountry: Bool) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self._remainingCountries.indices {
        
        if self.didUpdateCountries {
          self.didUpdateCountries = false
          self.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
          return
        }
        
        let isIndexValid = self._remainingCountries.indices.contains(i)
        
        if isIndexValid {
          
          let flag = self._remainingCountries[i].flag as! NSString
          
          if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
            
            var image = UIImage()
            var imageStr = String()
            
            if isRemainingCountry {
              
              imageStr = self._remainingCountries[i].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._remainingCountries[i].flag)!
              
            } else {
              
              imageStr = self._remainingCountries[i].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._remainingCountries[i].flag)!
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
        
        let isIndexValid = self._remainingCountries.indices.contains(i.row)
        
        if isIndexValid {
          
          
          let flag = self._remainingCountries[i.row].flag as! NSString
          
          if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
            
            var image = UIImage()
            var imageStr = String()
            
            if isRemainingCountry {
              
              imageStr = self._remainingCountries[i.row].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._remainingCountries[i.row].flag)!
              
            } else {
              
              imageStr = self._remainingCountries[i.row].flagSmall
              
              image = UIImage(named: imageStr) ?? UIImage(named: self._remainingCountries[i.row].flag)!
            }
            
            let smallImage = self.resizeImage(image: image, newWidth: 200)
            self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          }
        }
      }
    }
  }
  
//  
//  //MARK: - PRIVATE FUNCTIONS
//  
//  private func setchosenCountries() {
//    
//    guard let allCountries = createCountries() else { print("json error"); return }
//    
//    _chosenCountries = allCountries.filter { c -> Bool in
//      
//      for i in _remainingCountries {
//        if c == i {
//          return false
//        }
//      }
//      return true
//    }
//  }
  
}
