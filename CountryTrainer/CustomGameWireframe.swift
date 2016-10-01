//
//  CustomGameWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  fileprivate var countries: [Country]?
  fileprivate var customGameInteractor: CustomGameInteractor?
  fileprivate var customGameVC: CustomGameVC?
  fileprivate var presentedViewController: UIViewController?
  
  internal weak var mainWireframe: MainWireframe?
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func beginGame(game: Game) {
    
    customGameVC?.navigationController?.popViewController(animated: false)
    self.mainWireframe?.presentCustomGameInterface(withGame: game)

//    dismiss(animated: false, completion: {
//      self.mainWireframe?.presentGameInterface(withGame: game)
//    })
  }
  
  internal func presentCustomGameFromVC(viewController: UIViewController!, countries: [Country]) {
    
    self.countries = countries
    
    customGameInteractor = CustomGameInteractor(countries: countries)
    
    let newVC = customGameViewController()
    newVC.transitioningDelegate = self
    newVC.customGameWireframe = self
    newVC.customGameInteractor = customGameInteractor
    newVC.navigationController?.enableRadialSwipe()
    
    customGameVC = newVC
    
    viewController.navigationController?.radialPushViewController(viewController: newVC)
    
    presentedViewController = newVC
    
  }
  
  internal func dismisscustomGameVCToMainVC(withCountries countries: [Country]) {
    mainWireframe?.updateFilteredCountries(countries: countries)
    
    let frame = CGRect(x: 0, y: 25, width: 40, height: 40)
    
    presentedViewController?.navigationController?.radialPopViewController(duration: 0.3, startFrame: frame, transitionCompletion: nil)
    
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func customGameViewController() -> CustomGameVC {
    let storyboard = mainStoryboard()
    let customGameVC = storyboard.instantiateViewController(withIdentifier: "customGame") as! CustomGameVC
    return customGameVC
  }
  
  private func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
  }
  
  
  //MARK: TRANSITION DELEGATE
  
  internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentingAnimator()
    
  }
  internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()
    
  }
}
