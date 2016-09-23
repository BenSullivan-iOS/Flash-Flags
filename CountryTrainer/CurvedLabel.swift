//
//  CurvedLabel.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 21/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CurvedLabel: UILabel {
  
  override func awakeFromNib() {
    layer.cornerRadius = 5.0
    layer.masksToBounds = true
    backgroundColor = UIColor.white
    alpha = 0.95
  }
}
