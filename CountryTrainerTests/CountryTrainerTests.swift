//
//  CountryTrainerTests.swift
//  CountryTrainerTests
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import XCTest
@testable import CountryTrainer

class CountryTrainerTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testDataService() {
    
    let vc = ViewController()
    XCTAssertNotNil(vc.createCountries())
  }
  
  func testGame() {
    
    let countries = [Country(name: "England", currency: "GBP", flag: "UK", continent: Continent.Europe),
    Country(name: "Ireland", currency: "GBP", flag: "IR", continent: Continent.Asia),
    Country(name: "Wales", currency: "GBP", flag: "UK", continent: Continent.Africa),
    Country(name: "England", currency: "GBP", flag: "UK", continent: Continent.None)
    ]
    
    let g = Game(countries: countries)
    
    XCTAssert(g.numberOfFlags == 4)
    XCTAssert(g.progress == "0/4")
    
    for i in countries.indices {
      XCTAssert(g.countries[i] == countries[i])
    }
  }
  
  func testGameTracker() {
    
    let england = Country(name: "England", currency: "GBP", flag: "UK", continent: Continent.Europe)
    let ireland = Country(name: "Ireland", currency: "EUR", flag: "IR", continent: Continent.Asia)
    
    let countries = [england, ireland]
    
    var g = Game(countries: countries)
    
    XCTAssert(g.tracker.answers == ["England" : false, "Ireland" : false])
    
    g.tracker.updateTracker("England", result: true)
    XCTAssert(g.tracker.answers["England"] == true)

    g.tracker.removeRemainingCountry(at: 0)
    XCTAssert(g.tracker.remainingCountries[0] == ireland)
    XCTAssert(g.tracker.remainingCountries.count == 1)
    
    g.tracker.removeRemainingCell(country: england.name)
    XCTAssert(g.tracker.remainingCells == [ireland.name : false])
    
    
    g.tracker.updateTracker("Ireland", result: true)
    g.tracker.removeRemainingCountry(at: 0)
    g.tracker.removeRemainingCell(country: ireland.name)

    XCTAssert(g.tracker.answers["England"] == true)
    XCTAssert(g.tracker.answers["Ireland"] == true)
    XCTAssert(g.tracker.remainingCountries.isEmpty)
    XCTAssert(g.tracker.remainingCells.isEmpty)
  }
  
  func testCountry() {
    
    let country = Country(name: "England", currency: "GBP", flag: "UK", continent: Continent.Europe)
    
    XCTAssert(country.name == "England")
    XCTAssert(country.currency == "GBP")
    XCTAssert(country.flag == "UK")
    XCTAssert(country.cont == Continent.Europe)
    
  }
  
  func testContinent() {
    
    XCTAssert(Continent.Oceania.rawValue == "Oceania")
    XCTAssert(Continent.Africa.rawValue == "Africa")
    XCTAssert(Continent.Asia.rawValue == "Asia")
    XCTAssert(Continent.Americas.rawValue == "Americas")
    XCTAssert(Continent.Europe.rawValue == "Europe")
    XCTAssert(Continent.None.rawValue == "")

  }
}
