//
//  ViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataService {
  
  @IBOutlet weak var flagImage: UIImageView!
  
  fileprivate var countries = [Country]()
  fileprivate var chosenOnes = [Country]()
  fileprivate var newGame: Game? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let dest = segue.destination as? TableViewController {
      
//      dest.countries = chosenOnes
      dest.game = newGame!
      
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    flagImage.contentMode = .scaleAspectFit
    
    startNewGame()
    
  }
  
  func startNewGame() {
    
    let numberOfFlagsSelected = 5
    
    for _ in 1...numberOfFlagsSelected {
      chosenOnes.append(countries[Int(arc4random_uniform(236))])
      
      print(chosenOnes.count)
      
    }
    
    newGame = Game(countries: chosenOnes)

  }
  
  @IBAction func correctAnswer(_ sender: UIButton) {
    print(countries.count)
    print(countries)
      newGame?.updateTracker(chosenOnes[Int(arc4random_uniform(5))].name, result: true)
    
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
