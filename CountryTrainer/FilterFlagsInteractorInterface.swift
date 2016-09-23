//
//  FilterFlagsInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol FilterFlagsInteractorInterface {
  
  func removeFlag(country: Country) -> IndexPath?
  func addFlag(country: Country) -> IndexPath?
  
  func populateCurrentCoutntriesCache(isRemainingCountry: Bool)
  func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath])
  
  var imageCache: NSCache<NSString, UIImage> { get }

  func setCountries(countryArray: [Country])
  var countries: [Country] { get }
  var remainingCountries: [Country] { get }
  var memorisedCountries: [Country] { get }
  
  func saveToCoreData(remainingCountries: [Country])
  
  func resetAllFlags() -> Bool

}
