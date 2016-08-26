//
//  resultButton.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 26/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class ResultButton: UIButton {
  
  override func awakeFromNib() {
    
    layer.cornerRadius = 2.0
    layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5).cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 5.0
    layer.shadowOffset = CGSize(width: 0, height: 2)

  }
}
