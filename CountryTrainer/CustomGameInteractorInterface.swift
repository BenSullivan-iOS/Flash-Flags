//
//  CustomGameInteractorInterface.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol CustomGameInteractorInterface {
  
  var remainingCountries: [Country] { get }
  var chosenCountries: [Country] { get }
  var imageCache: NSCache<NSString, UIImage> { get }
  var filteredCountries: [Country] { get }
  
  func filterCountries(withText text: String)
  func addFlag(country: Country, searchActive: Bool) -> IndexPath?
  func removeFlag(country: Country, searchActive: Bool) -> IndexPath?
  
  func populateCurrentCoutntriesCache(isRemainingCountry: Bool)
  func populateCacheFromPrefetch(isRemainingCountry: Bool, indexPaths: [IndexPath])
  
  func setCountries(countryArray: [Country])
  func saveToCoreData(remainingCountries: [Country])
}
