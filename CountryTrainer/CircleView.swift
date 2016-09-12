//
//  CircleView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class CircleView: UIView {
  
  var circleLayer: CAShapeLayer!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    assert(frame.size.width == frame.size.height, "A circle must have the same height and width.")
    self.addCircleLayer()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStrokeEnd(strokeEnd: CGFloat, animated: Bool) {
    if animated {
      self.animateToStrokeEnd(strokeEnd: strokeEnd)
      return
    }
    self.circleLayer.strokeEnd = strokeEnd
  }
  
  func setStrokeColor(strokeColor: UIColor) {
    self.circleLayer.strokeColor = strokeColor.cgColor
  }
  
  func addCircleLayer() {
    
    let lineWidth: CGFloat = 6.0
    let radius: CGFloat = self.bounds.width / 2 - lineWidth / 2
    self.circleLayer = CAShapeLayer()
    let rect = CGRect(x: lineWidth / 2, y: lineWidth / 2, width: radius * 2, height: radius * 2)
    self.circleLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
    self.circleLayer.strokeColor = self.tintColor.cgColor
    self.circleLayer.fillColor = nil
    self.circleLayer.lineWidth = lineWidth
    self.circleLayer.lineCap = kCALineCapRound
    self.circleLayer.lineJoin = kCALineJoinRound
    self.layer.addSublayer(self.circleLayer)
  }
  
  func animateToStrokeEnd(strokeEnd: CGFloat) {
    let strokeAnimation = POPSpringAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
    strokeAnimation?.toValue = strokeEnd
    //    strokeAnimation?.springBounciness = 15
    strokeAnimation?.dynamicsFriction = 200
    strokeAnimation?.removedOnCompletion = false
    self.circleLayer.pop_add(strokeAnimation!, forKey: "layerStrokeAnimation")
  }
}
