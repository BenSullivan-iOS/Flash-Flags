//
//  PresentResult.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

let customBlueColor = UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1)

class PresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view!
    fromView.tintAdjustmentMode = .dimmed
    fromView.isUserInteractionEnabled = false
    let dimmingView = UIView(frame: fromView.bounds)
    dimmingView.backgroundColor = .gray
    dimmingView.layer.opacity = 0.0
    
    let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view!
    toView.frame = CGRect(x: 0, y: 0, width: transitionContext.containerView.bounds.width - 104.0, height: transitionContext.containerView.bounds.height - 288.0)
    toView.center = CGPoint(x: transitionContext.containerView.center.x, y: -transitionContext.containerView.center.y)
    
    transitionContext.containerView.addSubview(dimmingView)
    transitionContext.containerView.addSubview(toView)
    
    let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
    positionAnimation?.toValue = transitionContext.containerView.center.y
    positionAnimation?.springBounciness = 10
    positionAnimation!.completionBlock = {(anim: POPAnimation?, finished: Bool) -> Void in
      transitionContext.completeTransition(true)
    }
    let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
    scaleAnimation?.springBounciness = 20
    scaleAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 1.2, y: 1.4))
    let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    opacityAnimation?.toValue = 0.2
    toView.layer.pop_add(positionAnimation!, forKey: "positionAnimation")
    toView.layer.pop_add(scaleAnimation!, forKey: "scaleAnimation")
    dimmingView.layer.pop_add(opacityAnimation!, forKey: "opacityAnimation")
  }
}
