//
//  StartNewGameVCPickerExt.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 19/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension StartNewGameVC: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    var pickerLabel = view as? UILabel
    
    stylePickerText(&pickerLabel)
    
    setPickerTitles(pickerView, pickerLabel, row)
    
    return pickerLabel!
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    switch pickerView {
      
    case numberOfFlagsPicker:
      selectedNumOfFlags = numberOfFlags[row]
      
    case continentPicker:
      selectedContinent = continents[row]
      
    case difficultyPicker:
      selectedDifficulty = difficulties[row]
      
    default : break
      
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    switch pickerView {
      
    case continentPicker:
      return continents.count
      
    case numberOfFlagsPicker:
      return numberOfFlags.count
      
    default:
      return difficulties.count
    }
  }
  
  fileprivate func setPickerTitles(_ pickerView: UIPickerView, _ pickerLabel: UILabel?, _ row: Int) {
    
    switch pickerView {
      
    case numberOfFlagsPicker:
      pickerLabel?.text = String(numberOfFlags[row])
      
      if row == 0 {
        pickerLabel?.text = "How many flags? 🤔"
      }
    case continentPicker:
      pickerLabel?.text = continents[row]
      
    case difficultyPicker:
      pickerLabel?.text = difficulties[row]
      
    default : break
      
    }
  }
  
  fileprivate func stylePickerText(_ pickerLabel: inout UILabel?) {
    
    if pickerLabel == nil {
      
      pickerLabel = UILabel()
      pickerLabel?.font = UIFont(name: "Lato-Regular", size: 20)
      pickerLabel?.textAlignment = .center
      
    } else {
      
      pickerLabel?.font = UIFont(name: "Lato-Regular", size: 20)
      
    }
  }
}
