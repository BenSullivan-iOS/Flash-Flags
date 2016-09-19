//
//  FlagImageView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class FlagImageView: UIImageView {
  
  func animate() {
    let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
    scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
    scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
    scaleAnim?.springBounciness = 18
    self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
  }
}
