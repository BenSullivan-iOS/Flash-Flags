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
            let flag = i["cca2"]! as? String,
            let difficulty = i["difficulty"] as? String {
            
            if let currencyStr = currencyObj.firstObject as? String {
              
              var continent = Continent.all
              
              switch cont {
                
              case Continent.oceania.rawValue:
                continent = Continent.oceania
                
              case Continent.africa.rawValue:
                continent = Continent.africa
                
              case Continent.americas.rawValue:
                continent = Continent.americas
                
              case Continent.asia.rawValue:
                continent = Continent.asia
                
              case Continent.europe.rawValue:
                continent = Continent.europe
                
              case Continent.all.rawValue:
                continent = Continent.all
                
              default: break
              }
              
              var flagDifficulty = Difficulty.allDifficulties
              
              switch difficulty {
                
              case "easy":
                flagDifficulty = Difficulty.easy
              case "medium":
                flagDifficulty = Difficulty.medium
              case "hard":
                flagDifficulty = Difficulty.hard
                
              default: break
              }
              
              countries.append(Country(
                name: commonName,
                currency: currencyStr,
                flag: flag.lowercased(),
                continent: continent,
                difficulty: flagDifficulty))
            }
          }
        }
        
        return countries
        
      } catch {
        print("POPULATE COUNTRY JSON ERROR")
        print(error)
        
        return nil
      }
    }
    return nil
  }
}
