//
//  FlagImageView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

//@IBDesignable
class FlagImageView: UIImageView {
  
//  @IBInspectable var shadowOpacity: Float = 0.8 {
//    didSet {
//      layer.shadowOpacity = self.shadowOpacity
//    }
//  }
//  
//  @IBInspectable var shadowRadius: CGFloat = 3.0 {
//    didSet {
//      layer.shadowRadius = self.shadowRadius
//    }
//  }
  
  override func awakeFromNib() {
    
    let SHADOW_COLOR: CGFloat = 157.0 / 255.0

    layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor

    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    
    
    
  }
  func animate() {
  let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
  scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
  scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
  scaleAnim?.springBounciness = 18
  self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
  }
}
