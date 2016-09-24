//
//  GameWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  fileprivate var addPresenter: GameVC?
  fileprivate var presentedViewController: UIViewController?
  fileprivate var gameInteractor: GameInteractor?
  fileprivate var resultInteractor: ResultInteractor?
  fileprivate var gameVC: GameVC?
  
  internal var mainWireframe: MainWireframe?
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func dismissResultVCToEndGame(game: Game) {
    
    presentedViewController?.dismiss(animated: true, completion: nil)
    dismissGameInterface()
    mainWireframe?.gameCompleted(game: game)
  }
  
  internal func dismissResultVCToRetry() {
    
    presentedViewController?.dismiss(animated: true, completion: nil)
    
    gameVC?.retryGame()
  }
  
  internal func presentGameInterfaceFromViewController(viewController: UIViewController, withGame game: Game) {
    
    gameInteractor = GameInteractor(game: game)
    
    let newVC = gameViewController()
    newVC.transitioningDelegate = self
    newVC.gameWireframe = self
    newVC.gameInteractorInterface = gameInteractor
    gameVC = newVC
    
    viewController.navigationController?.radialPushViewController(viewController: newVC)
    presentedViewController = newVC

  }
  
  internal func presentResultInterfaceFrom(viewController: UIViewController, scoreInt: Int, scoreString: String) {
    
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
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func dismissGameInterface() {
    _ = presentedViewController?.navigationController?.popViewController(animated: true)
  }
  
  private func resultVC() -> ResultVC {
    let storyboard = mainStoryboard()
    let gameVC: ResultVC = storyboard.instantiateViewController(withIdentifier: "resultVC") as! ResultVC
    return gameVC
  }

  
  private func gameViewController() -> GameVC {
    let storyboard = mainStoryboard()
    let gameVC: GameVC = storyboard.instantiateViewController(withIdentifier: "gameVC") as! GameVC
    return gameVC
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
