//
//  StartNewGameVC.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 15/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

//ALLOW USERS TO SELECT A CONTINENT AND AMOUNT OF FLAGS
import UIKit

class StartNewGameVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet weak var continentPicker: UIPickerView!
  @IBOutlet weak var numberOfFlagsPicker: UIPickerView!
  
  var mainInteractor: MainInteractorInterface?
  
  //Settings for a default game

  fileprivate var continents = ["Select Continent", "All"]
  fileprivate var numberOfFlags = [Int]()
  
  fileprivate var selectedContinent = "All"
  fileprivate var selectedNumOfFlags = 5
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let contData = mainInteractor?.prepareContinentsForPicker(),
      let flagData = mainInteractor?.prepareNumberOfFlagsForPicker() {
      
      continents += contData
      numberOfFlags += flagData
    }
    
    numberOfFlagsPicker.selectRow(5, inComponent: 0, animated: false)
    
    view.layer.cornerRadius = 8.0
  }
  
  @IBAction func startGameButtonPressed(_ sender: UIButton) {
    
    mainInteractor?.getNewGameData(numberOfFlags: selectedNumOfFlags, continent: selectedContinent)
  }

  //MARK: PICKER DELEGATE / DATASOURCE
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    if pickerView == numberOfFlagsPicker {
      
      selectedNumOfFlags = numberOfFlags[row]
    }
    
    if pickerView == continentPicker {

      selectedContinent = continents[row]
    }
  }
 
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == continentPicker {
      
      return continents.count
    }
    
    return numberOfFlags.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if pickerView == continentPicker {
     
      return continents[row]
    }
    if row == 0 {
      return "How many flags? 🤔"
    }
    return String(numberOfFlags[row])
  }
  

}
