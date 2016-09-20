//
//  GameProgressView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameProgressView: UIProgressView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    progress = 0
    layer.cornerRadius = 12.5
    clipsToBounds = true
    alpha = 0.8
  }
}
