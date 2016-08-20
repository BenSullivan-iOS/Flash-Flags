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
    
    let i = 0
    i.distance(to: 2)
    
  }
  
  func testCountry() {
    
    let country = Country(name: "England", currency: "GBP", flag: "UK", continent: Continent.Europe)
    
    XCTAssert(country.name == "England")
    XCTAssert(country.currency == "GBP")
    XCTAssert(country.flag == "UK")
    XCTAssert(country.cont == Continent.Europe)
    
  }
  
  func testGame() {
    
//    let i = Game
    
  }
}
