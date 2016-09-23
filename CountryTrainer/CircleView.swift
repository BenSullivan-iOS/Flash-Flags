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
  var lineWidth: CGFloat = 6.0
  
  init(frame: CGRect, lineWidth: CGFloat = 6.0) {
    
    self.lineWidth = lineWidth
    
    super.init(frame: frame)
    
    self.addCircleLayer()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStrokeEnd(strokeEnd: CGFloat, animated: Bool, friction: CGFloat?) {
    if animated {
      self.animateToStrokeEnd(strokeEnd: strokeEnd, friction: friction ?? nil)
      return
    }
    self.circleLayer.strokeEnd = strokeEnd
  }
  
  func setStrokeColor(strokeColor: UIColor) {
    self.circleLayer.strokeColor = strokeColor.cgColor
  }
  
  func addCircleLayer() {
    
    let radius: CGFloat = self.bounds.width / 2 - lineWidth / 2
    self.circleLayer = CAShapeLayer()
    let rect = CGRect(x: lineWidth / 2, y: lineWidth / 2, width: radius * 2, height: radius * 2)
    self.circleLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
    self.circleLayer.strokeColor = UIColor(colorLiteralRed: 0/255, green: 99/255, blue: 224/255, alpha: 0.8).cgColor
    //self.tintColor.cgColor
    self.circleLayer.fillColor = nil
    self.circleLayer.lineWidth = lineWidth
    self.circleLayer.lineCap = kCALineCapRound
    self.circleLayer.lineJoin = kCALineJoinRound
    self.layer.addSublayer(self.circleLayer)
  }
  
  func animateToStrokeEnd(strokeEnd: CGFloat, friction: CGFloat?) {
    let strokeAnimation = POPSpringAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
    strokeAnimation?.toValue = strokeEnd
    //    strokeAnimation?.springBounciness = 15
    strokeAnimation?.dynamicsFriction = friction ?? 200
    strokeAnimation?.removedOnCompletion = false
    self.circleLayer.pop_add(strokeAnimation!, forKey: "layerStrokeAnimation")
  }
}
