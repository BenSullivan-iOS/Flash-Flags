//
//  GameWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  var addPresenter: GameVC?
  var presentedViewController: UIViewController?
  
  func presentGameInterfaceFromViewController(viewController: UIViewController, withGame game: Game) {
    
    let gameInteractor = GameInteractor()
    
    let newVC = gameViewController()
    newVC.transitioningDelegate = self
    newVC.game = game
    newVC.gameWireframe = self
    
    newVC.gameInteractorInterface = gameInteractor
    
    viewController.navigationController?.radialPushViewController(viewController: newVC)
    presentedViewController = newVC

  }
  
  func presentResultInterfaceFrom(viewController: UIViewController, scoreInt: Int, scoreString: String) {
    
    let newVC = resultVC()
    newVC.transitioningDelegate = self
    newVC.modalPresentationStyle = UIModalPresentationStyle.custom
    newVC.gameScoreInt = scoreInt
    newVC.gameScoreString = scoreString
    
    viewController.navigationController!.present(newVC, animated: true, completion: nil)
  }
  
  func resultVC() -> ResultVC {
    let storyboard = mainStoryboard()
    let gameVC: ResultVC = storyboard.instantiateViewController(withIdentifier: "resultVC") as! ResultVC
    return gameVC
  }

  
  func gameViewController() -> GameVC {
    let storyboard = mainStoryboard()
    let gameVC: GameVC = storyboard.instantiateViewController(withIdentifier: "gameVC") as! GameVC
    return gameVC
  }
  
  func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
  }
  
  //MARK: TRANSITION DELEGATE
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentingAnimator()
    
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()
    
  }
}
