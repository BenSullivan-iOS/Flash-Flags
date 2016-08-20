//
//  DataService.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 15/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

protocol DataService {
  func createCountries() -> [Country]?
}

extension DataService {
  
  func createCountries() -> [Country]? {
    
    if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
    
    do {
        
        var countries = [Country]()
        
        let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
        
        let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        
        for country in jsonResult {
          
          let i = country as! [String: AnyObject]
          
          if let name = i["name"] as AnyObject?,
            let commonName = name["common"] as? String,
            let cont = i["region"]! as? String,
            let currencyObj = i["currency"] as! NSArray?,
            let flag = i["cca2"]! as? String {
          
            if let currencyStr = currencyObj.firstObject as? String {
              
              var continent = Continent.None
              
              switch cont {
                
              case Continent.Oceania.rawValue:
                continent = Continent.Oceania
                
              case Continent.Africa.rawValue:
                continent = Continent.Africa

              case Continent.Americas.rawValue:
                continent = Continent.Americas

              case Continent.Asia.rawValue:
                continent = Continent.Asia

              case Continent.Europe.rawValue:
                continent = Continent.Europe

              case Continent.None.rawValue:
                continent = Continent.None
                
              default: break

              }
              countries.append(Country(name: commonName, currency: currencyStr, flag: flag.lowercased(), continent: continent))
            }
          }
        }
        
        return countries
        
      } catch {
        print("POPULATE ARRAYS ERROR")
        print(error)
        
        return nil
      }
    }
    return nil
  }
}
