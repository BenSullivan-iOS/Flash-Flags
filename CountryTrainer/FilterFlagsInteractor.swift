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
  
  fileprivate var _imageCache = NSCache<NSString, UIImage>()
  
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
  
  init(countries: [Country]) {
    setCountries(countryArray: countries)
    _remainingCountries = countries
    setMemorisedCountries()
  }
  
  func setCountries(countryArray: [Country]) {
    _countries = countryArray
  }
  
  func setMemorisedCountries() {
    
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
  
  func saveToCoreData(remainingCountries: [Country]) {
    saveRemainingCountriesToCoreData(remainingCountries: remainingCountries)
  }
  
  func addFlag(country: Country) -> IndexPath? {
    
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
  
  func removeFlag(country: Country) -> IndexPath? {
    
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

  func populateCurrentCoutntriesCache(isRemainingCountry: Bool) {
   
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in self.countries.indices {
        
        if self.didUpdateCountries {
          self.didUpdateCountries = false
          self.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
          return
        }
        
        let flag = self.countries[i].flag as! NSString
        
        if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
          
          var image = UIImage()
          var imageStr = String()
          
          if isRemainingCountry {
            
            imageStr = self.remainingCountries[i].flagSmall
            
            image = UIImage(named: imageStr) ?? UIImage(named: self.remainingCountries[i].flag)!
            
          } else {
            
            imageStr = self.memorisedCountries[i].flagSmall
            
            image = UIImage(named: imageStr) ?? UIImage(named: self.memorisedCountries[i].flag)!
          }
          
          let smallImage = self.resizeImage(image: image, newWidth: 200)
          self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          print(i)
        }
      }
    }
  }
  
  func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        
        let flag = self.remainingCountries[i.row].flag as! NSString
        
        if self.imageCache.object(forKey: "\(flag)-1" as NSString) == nil && self.imageCache.object(forKey: flag) == nil {
          
          var image = UIImage()
          var imageStr = String()
          
          if isRemainingCountry {
            
            imageStr = self.remainingCountries[i.row].flagSmall
            
            image = UIImage(named: imageStr) ?? UIImage(named: self.remainingCountries[i.row].flag)!
            
          } else {
            
            imageStr = self.memorisedCountries[i.row].flagSmall
            
            image = UIImage(named: imageStr) ?? UIImage(named: self.memorisedCountries[i.row].flag)!
          }
          
          let smallImage = self.resizeImage(image: image, newWidth: 200)
          self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
          print(i)
        }
      }
    }
  }
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}
