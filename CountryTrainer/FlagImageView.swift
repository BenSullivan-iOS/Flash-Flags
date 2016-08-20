//
//  FlagImageView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FlagImageView: UIImageView {
  
  override func awakeFromNib() {
    
    let SHADOW_COLOR: CGFloat = 157.0 / 255.0

    layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 3.0
    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
  }
}
