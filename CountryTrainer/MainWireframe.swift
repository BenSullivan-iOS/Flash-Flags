//
//  MainVCWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  var mainVC: MainVC?
  var mainInteractor: MainInteractor?
  var gameWireframe: GameWireframe?
  var rootWireframe: RootWireframe?
  var filterFlagsWireframe: FilterFlagsWireframe?
  var startNewGameVC: StartNewGameVC?
  
  func updateFilteredCountries(countries: [Country]) {
    mainVC?.updateCountriesAfterFilter(countries: countries)
  }
  
  func presentFilterFlagsInterface(withCountries countries: [Country]) {
    
    filterFlagsWireframe?.presentFilterFlagsInterfaceFromViewController(viewController: mainVC!, countries: countries)
  }
  
  func presentStartNewGameVCFromMainVC() {
    
    startNewGameVC = startNewGameViewController()
    startNewGameVC?.transitioningDelegate = self
    startNewGameVC?.modalPresentationStyle = UIModalPresentationStyle.custom
    startNewGameVC?.mainInteractor = mainInteractor
    mainInteractor?.startNewGameVCInterface = startNewGameVC
    
    mainVC!.navigationController!.present(startNewGameVC!, animated: true, completion: nil)
  }
  
  func gameCompleted(game: Game) {
    mainVC?.populateGames(game: game)
  }
  
  func presentGameInterface(withGame game: Game) {
    
    mainVC?.dismiss(animated: true, completion: nil)
    gameWireframe?.presentGameInterfaceFromViewController(viewController: mainVC!, withGame: game)
  }

  func presentMainVCInterfaceFromWindow(window: UIWindow) {
    
    let viewController = mainVCFromStoryboard()

    //configure local variables
    mainVC = viewController
    mainInteractor = MainInteractor()
    
    //Set delegates
    mainVC?.mainWireframe = self
    mainVC?.mainInteractor = mainInteractor
    mainInteractor?.mainVCInterface = mainVC
    
    rootWireframe?.showRootViewController(viewController: viewController, inWindow: window)
  }
  
  func mainVCFromStoryboard() -> MainVC {
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! MainVC
    return viewController
  }
  
  func startNewGameViewController() -> StartNewGameVC {
    let storyboard = mainStoryboard()
    let startNewGameVC = storyboard.instantiateViewController(withIdentifier: "startNewGameVC") as! StartNewGameVC
    return startNewGameVC
  }
  
  func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
  }

  
  //TRANSITION DELEGATE
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentStartNewGame()
    
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()
    
  }
}
