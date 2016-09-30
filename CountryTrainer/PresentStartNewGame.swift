//
//  PresentStartNewGame.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class PresentStartNewGame: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using trans: UIViewControllerContextTransitioning) {
    
    let fromView = createFromView(trans)
    let dimmingView = createDimmingView(fromView)
    
    let toView = createToView(trans)
    
    trans.containerView.addSubview(dimmingView)
    trans.containerView.addSubview(toView)
    
    toView.layer.pop_add(positionAnimation(trans), forKey: "positionAnimation")
    toView.layer.pop_add(scaleAnimation(), forKey: "scaleAnimation")
    
    dimmingView.layer.pop_add(opacityAnimation(), forKey: "opacityAnimation")
  }
  
  func opacityAnimation() -> POPBasicAnimation {
    
    let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    opacityAnimation?.toValue = 0.2
    
    return opacityAnimation!
  }
  
  
  func scaleAnimation() -> POPSpringAnimation {
    
    let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
    scaleAnimation?.springBounciness = 20
    scaleAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 1.2, y: 1.4))
    
    return scaleAnimation!
  }
  
  
  func positionAnimation(_ trans: UIViewControllerContextTransitioning) -> POPSpringAnimation {
    
    let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
    positionAnimation?.toValue = trans.containerView.center.y
    positionAnimation?.springBounciness = 10
    positionAnimation!.completionBlock = {(anim: POPAnimation?, finished: Bool) -> Void in
      trans.completeTransition(true)
    }
    return positionAnimation!
  }
  
  func createToView(_ trans: UIViewControllerContextTransitioning) -> UIView {
    
    let toView = trans.viewController(forKey: .to)!.view!
    toView.frame = CGRect(x: 0, y: 0, width: trans.containerView.bounds.width - 40, height: trans.containerView.bounds.height - 180.0) //was 250
    
    toView.center = CGPoint(x: trans.containerView.center.x, y: -trans.containerView.center.y)
    
    return toView
  }
  
  func createDimmingView(_ fromView: UIView) -> UIView {
    
    let dimView = UIView(frame: fromView.bounds)
    dimView.backgroundColor = .gray
    dimView.layer.opacity = 0.0
    
    return dimView
  }
  
  func createFromView(_ trans: UIViewControllerContextTransitioning) -> UIView {
    
    let fromView = trans.viewController(forKey: UITransitionContextViewControllerKey.from)!.view!
    fromView.tintAdjustmentMode = .dimmed
    fromView.isUserInteractionEnabled = false
    
    return fromView
  }
  
}
