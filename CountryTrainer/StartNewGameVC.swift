//
//  StartNewGameVC.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 15/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

class StartNewGameVC: UIViewController, StartNewGameVCInterface {
  
  @IBOutlet weak var continentPicker: UIPickerView!
  @IBOutlet weak var numberOfFlagsPicker: UIPickerView!
  
  var mainInteractor: MainInteractorInterface?
  
  var continents = ["Select Continent", "All"]
  var numberOfFlags = [Int]()
  
  //Settings for a default game
  var selectedContinent = "All"
  var selectedNumOfFlags = 5
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let contData = mainInteractor?.prepareContinentsForPicker(),
      let flagData = mainInteractor?.prepareNumberOfFlagsForPicker() {
      
      continents += contData
      numberOfFlags += flagData
    }
    
    view.layer.cornerRadius = 8.0
  }
  
  @IBAction func startGameButtonPressed(_ sender: UIButton) {
    mainInteractor?.getNewGameData(numberOfFlags: selectedNumOfFlags, continent: selectedContinent)
    
  }
  
  func displayAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Thanks! 😍", style: .default, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
}
