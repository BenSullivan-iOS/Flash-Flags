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
    
    if pickerLabel == nil {
      
      pickerLabel = UILabel()
      pickerLabel?.font = UIFont(name: "Lato-Regular", size: 20)
      pickerLabel?.textAlignment = .center
      
    } else {
      
      pickerLabel?.font = UIFont(name: "Lato-Regular", size: 20)
      
    }
    
    if pickerView == numberOfFlagsPicker {
      
      pickerLabel?.text = String(numberOfFlags[row])
      
      if row == 0 {
        pickerLabel?.text = "How many flags? 🤔"
      }
      
    } else if pickerView == continentPicker {
      
      pickerLabel?.text = continents[row]
      
    } else if pickerView == difficultyPicker {
      
      pickerLabel?.text = difficulties[row]
    }
    
    return pickerLabel!
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    if pickerView == numberOfFlagsPicker {
      selectedNumOfFlags = numberOfFlags[row]
    }
    
    if pickerView == continentPicker {
      selectedContinent = continents[row]
    }
    
    if pickerView == difficultyPicker {
      selectedDifficulty = difficulties[row]
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == continentPicker {
      return continents.count
    }
    
    if pickerView == numberOfFlagsPicker {
      return numberOfFlags.count
    }
    
    return difficulties.count
  }
}
