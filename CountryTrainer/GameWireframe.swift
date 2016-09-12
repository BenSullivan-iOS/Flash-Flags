//
//  GameWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  var addPresenter : GameVC?
  var presentedViewController : UIViewController?
  
  func presentGameInterfaceFromViewController(viewController: UIViewController, withGame game: Game) {
    
    let newViewController = gameViewController()
//    newViewController.eventHandler = addPresenter
//    newViewController.modalPresentationStyle = .Custom
    newViewController.transitioningDelegate = self
    newViewController.game = game
    
//    addPresenter?.configureUserInterfaceForPresentation(newViewController)
    
    //    let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameVC
    
    //    gameVC.game = game
    
//        newViewController.navigationController.radialPushViewController(viewController: gameVC, duration: 0.5, startFrame: newGameButton.frame, transitionCompletion: nil)
    
    viewController.navigationController?.radialPushViewController(viewController: newViewController)
    
//    viewController.present(newViewController, animated: true, completion: nil)
    
    presentedViewController = newViewController

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
}
