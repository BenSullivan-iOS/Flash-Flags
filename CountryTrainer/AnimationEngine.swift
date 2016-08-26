//
//  AnimationEngine.swift
//  BrainTeaser Facebook Pop Animation Test
//
//  Created by Ben Sullivan on 22/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop
import CoreGraphics

struct AnimationEngine {
  
  static let bounds = UIScreen.main.bounds
  
  static var offScreenRightPosition: CGPoint {
    return CGPoint(x: bounds.width, y: bounds.midY)
  }
  
  static var offScreenLeftPosition: CGPoint {
    return CGPoint(x: -bounds.width, y: bounds.midY)
  }
  
  static var screenCenterPosition: CGPoint {
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }
  
  var originalConstants = [CGFloat]()
  var constraints = [NSLayoutConstraint]()
  
  let animDelay = 0.8
  
  init(constraints: [NSLayoutConstraint]) {
    
    for con in constraints {
      
      originalConstants.append(con.constant)
      con.constant = AnimationEngine.offScreenRightPosition.x
    }
    self.constraints = constraints
  }
  
  func animateOnScreen(delay: Double?) {
    
    let time = DispatchTime.now() + (delay ?? animDelay)
    
    DispatchQueue.main.asyncAfter(deadline: time, execute: {
      
      var index = 0
      
      repeat {
        
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        
        moveAnim?.toValue = self.originalConstants[index]
        moveAnim?.springBounciness = 100
        moveAnim?.springSpeed = 0.1
        
        let con = self.constraints[index]
        con.pop_add(moveAnim, forKey: "moveOnScreen")
        
        index += 1
        
      } while index < self.constraints.count
    })
  }
  
  static func animateToPosition(view: UIView, position: CGPoint, completion: ((POPAnimation?, Bool) -> Void)) {
    
    let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
    moveAnim?.toValue = NSValue(cgPoint: position)
    moveAnim?.springSpeed = 8
    moveAnim?.springBounciness = 8
    moveAnim?.completionBlock = completion
    view.pop_add(moveAnim, forKey: "moveToPosition")
  }
  
  static func popView(view: UIView, velocity: NSValue) {
    
    let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
    scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
    scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
    scaleAnim?.springBounciness = 18
    view.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
    
  }
}









