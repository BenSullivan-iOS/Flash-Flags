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
  var mainWireframe: MainWireframe?
  var gameInteractor: GameInteractor?
  var resultInteractor: ResultInteractor?
  var gameVC: GameVC?
  
  func dismissGameInterface() {
    presentedViewController?.navigationController?.popViewController(animated: true)
  }
  
  func dismissResultVCToEndGame(game: Game) {
    
    presentedViewController?.dismiss(animated: true, completion: nil)
    dismissGameInterface()
    mainWireframe?.gameCompleted(game: game)
  }
  
  func dismissResultVCToRetry() {
    
    presentedViewController?.dismiss(animated: true, completion: nil)
    
    gameVC?.retryGame()
        
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retryGame"), object: nil)
  }
  
  func presentGameInterfaceFromViewController(viewController: UIViewController, withGame game: Game) {
    
    gameInteractor = GameInteractor(game: game)
    
    let newVC = gameViewController()
    newVC.transitioningDelegate = self
    newVC.gameWireframe = self
    newVC.gameInteractorInterface = gameInteractor
    gameVC = newVC
    
    viewController.navigationController?.radialPushViewController(viewController: newVC)
    presentedViewController = newVC

  }
  
  func presentResultInterfaceFrom(viewController: UIViewController, scoreInt: Int, scoreString: String) {
    
    let newVC = resultVC()
    resultInteractor = ResultInteractor()
    newVC.transitioningDelegate = self
    newVC.modalPresentationStyle = UIModalPresentationStyle.custom
    newVC.gameScoreInt = scoreInt
    newVC.gameScoreString = scoreString
    newVC.gameWireframe = self
    newVC.gameInteractorInterface = gameInteractor
    newVC.resultInteractor = resultInteractor
    
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
