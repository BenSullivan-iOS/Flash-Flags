//
//  FilterFlagsInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol FilterFlagsInteractorInterface {
  
  var countries: [Country] { get }
  var remainingCountries: [Country] { get }
  var memorisedCountries: [Country] { get }
  var imageCache: NSCache<NSString, UIImage> { get }

  func addFlag(country: Country) -> IndexPath?
  func removeFlag(country: Country) -> IndexPath?
  func resetAllFlags() -> Bool

  func populateCurrentCountriesCache(isRemainingCountry: FilterSelection)
  func populateCacheFromPrefetch(indexPaths: [IndexPath])

  func setCountries(countryArray: [Country])
  func saveToCoreData(remainingCountries: [Country])
}
