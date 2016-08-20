//
//  AnswerButtons.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 19/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class AnsweredCorrectlyButton: UIButton {
  
  override func awakeFromNib() {
    
    layer.cornerRadius = 3.0
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.green.cgColor
  
  }
}

class AnsweredIncorrectlyButton: UIButton {
  
  override func awakeFromNib() {
    
    layer.cornerRadius = 3.0
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.red.cgColor
    
  }
}
