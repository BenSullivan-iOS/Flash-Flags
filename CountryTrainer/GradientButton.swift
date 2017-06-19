//
//  GradientButton.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/11/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
  
  fileprivate var gradientLayer: CAGradientLayer?
  fileprivate var colors = [#colorLiteral(red: 0, green: 0.4526865697, blue: 0.8437882798, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.3394995246, blue: 0.6328125, alpha: 1).cgColor]
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    gradientLayer = getGradient()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
  }
  
  override func layoutSublayers(of layer: CALayer) {
    
    let rect = layer.bounds
    
    gradientLayer?.frame = rect
    gradientLayer?.colors = colors
    
    if layer.sublayers == nil {
      
      layer.addSublayer(gradientLayer!)
    }
    
    layoutSubviews()
    
    for i in subviews {
      
      if i.isKind(of: UILabel.self) {
        bringSubview(toFront: i)
      }
    }
  }
  
  func getGradient() -> CAGradientLayer {
    
    let gradientLayer: CAGradientLayer = {
      
      $0.startPoint = CGPoint(x: 1, y: 0)
      $0.endPoint = CGPoint(x: 0, y: 1)
      $0.cornerRadius = 8.0
      
      return $0
      
    }(CAGradientLayer())
    
    return gradientLayer
  }
}
