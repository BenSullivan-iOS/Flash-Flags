//
//  ViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class ViewController: UIViewController, DataService {
  
  @IBOutlet weak var flagImage: UIImageView!
  
  fileprivate var countries = [Country]()
  fileprivate var chosenOnes = [Country]()
  fileprivate var newGame: Game? = nil
  @IBOutlet weak var newGameButton: UIButton!
  
  private let numberOfFlagsSelected = 5
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    countries.removeAll()
    chosenOnes.removeAll()
    newGame = nil
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let dest = segue.destination as? TableViewController {
      
      dest.game = newGame!
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    flagImage.contentMode = .scaleAspectFit
    
    startNewGame()
    
  }
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    
    let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! TableViewController
    
    gameVC.game = newGame!
    
    self.navigationController?.radialPushViewController(viewController: gameVC, duration: 0.5, startFrame: newGameButton.frame, transitionCompletion: nil)
  }
  
  
  func startNewGame() {
    
    var chosenNumbers = Set<Int>()
    
    for _ in 1...numberOfFlagsSelected {
      
      chosenNumbers.insert(Int(arc4random_uniform(236)))
      
      print(chosenNumbers)
      
    }
    
    for i in chosenNumbers {
      
      chosenOnes.append(countries[i])
      print(countries[i])
    }
    
    newGame = Game(countries: chosenOnes)
    
  }
  
  @IBAction func correctAnswer(_ sender: UIButton) {
    //    print(countries.count)
    //    print(countries)
    //
    //    newGame?.tracker.updateTracker(chosenOnes[Int(arc4random_uniform(UInt32(numberOfFlagsSelected)))].name, result: true)
    
  }
}
