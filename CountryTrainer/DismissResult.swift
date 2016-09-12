 //
//  DismissResult.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class DismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    toVC.view.tintAdjustmentMode = .normal
    toVC.view.isUserInteractionEnabled = true
    
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    var dimmingView: UIView?
    
    for (_, value) in transitionContext.containerView.subviews.enumerated() {
      
      if value.layer.opacity < 1.0 {
        dimmingView = value
      }
    }
    
    let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    opacityAnimation?.toValue = 0.0
    
    let offscreenAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
    offscreenAnimation?.toValue = -fromVC.view.layer.position.y
    offscreenAnimation!.completionBlock = {(anim: POPAnimation?, finished: Bool) -> Void in
      transitionContext.completeTransition(true)
    }
    
    fromVC.view.layer.pop_add(offscreenAnimation!, forKey: "offscreenAnimation")
    dimmingView?.layer.pop_add(opacityAnimation!, forKey: "opacityAnimation")
  }
}
