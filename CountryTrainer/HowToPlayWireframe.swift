//
//  HowToPlayWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 29/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class HowToPlayWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  fileprivate var mainVC: MainVC?
  fileprivate var howToPlayVC: HowToPlayVC?
  
  internal var rootWireframe: RootWireframe?
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func presentHowToPlayFromVC(viewController: UIViewController!) {
    
    mainVC = viewController as! MainVC?
    
    howToPlayVC = howToPlayViewController()
    howToPlayVC?.transitioningDelegate = self
    howToPlayVC?.modalPresentationStyle = UIModalPresentationStyle.custom
    howToPlayVC?.howToPlayWireframe = self
      
    mainVC!.navigationController!.present(howToPlayVC!, animated: true, completion: nil)
  }
  
  internal func dismissHowToPlayVC() {
    
    howToPlayVC?.dismiss(animated: true, completion: nil)
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func mainVCFromStoryboard() -> MainVC {
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! MainVC
    return viewController
  }
  
  private func howToPlayViewController() -> HowToPlayVC {
    let storyboard = mainStoryboard()
    let howToPlayVC = storyboard.instantiateViewController(withIdentifier: "howToPlayVC") as! HowToPlayVC
    return howToPlayVC
  }
  
  private func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
  }
  
  
  //MARK: - TRANSITION DELEGATE
  
  internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentingAnimator()
    
  }
  internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()
    
  }
}
