//
//  CustomGameInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol CustomGameInteractorInterface {
  
  var countries: [Country] { get }
  var remainingCountries: [Country] { get }
  var chosenCountries: [Country] { get }
  var imageCache: NSCache<NSString, UIImage> { get }
  
  func addFlag(country: Country) -> IndexPath?
  func removeFlag(country: Country) -> IndexPath?
  func resetAllFlags() -> Bool
  
  func populateCurrentCoutntriesCache(isRemainingCountry: Bool)
  func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath])
  
  func setCountries(countryArray: [Country])
  func saveToCoreData(remainingCountries: [Country])
}
