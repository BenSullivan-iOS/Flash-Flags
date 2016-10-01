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
  
  var imageCache: NSCache<NSString, UIImage> {
    return _imageCache
  }
  
  var remainingCountries: [Country] {
    return _remainingCountries
  }
  
  var chosenCountries: [Country] {
    return _chosenCountries
  }
  
  
  //MARK: - INITIALISER
  
  init(countries: [Country]) {
    populateCountries()
    
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func setCountries(countryArray: [Country]) {
    _remainingCountries = countryArray
  }
  
  internal func saveToCoreData(remainingCountries: [Country]) {
    self.saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
  }
  
  internal func addFlag(country: Country) -> IndexPath? {
    
    for i in _chosenCountries.indices {
      
      if _chosenCountries[i] == country {
        didUpdateCountries = true
        _remainingCountries.insert(country, at: 0)
        _chosenCountries.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
    
  }
  
  internal func removeFlag(country: Country) -> IndexPath? {
    
    for i in remainingCountries.indices {
      
      if _remainingCountries[i] == country {
        
        didUpdateCountries = true
        _remainingCountries.remove(at: i)
        _chosenCountries.insert(country, at: 0)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        return indexPath
      }
    }
    return nil
  }
  
  internal func populateCountries() {
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    _remainingCountries.removeAll()
    _remainingCountries = countryArray
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
