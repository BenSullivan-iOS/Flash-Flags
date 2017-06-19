//
//  MainVCWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  fileprivate var mainVC: MainVC?
  fileprivate var mainInteractor: MainInteractor?
  fileprivate var startNewGameVC: StartNewGameVC?
  
  internal var howToPlayWireframe: HowToPlayWireframe?
  internal var gameWireframe: GameWireframe?
  internal var rootWireframe: RootWireframe?
  internal var filterFlagsWireframe: FilterFlagsWireframe?
  internal var customGameWireframe: CustomGameWireframe?
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func updateFilteredCountries(countries: [Country]) {
    mainVC?.updateCountriesAfterFilter(countries: countries)
  }
  
  internal func presentFilterFlagsInterface(withCountries countries: [Country], location: CGRect) {
    filterFlagsWireframe?.presentFilterFlagsInterfaceFromViewController(viewController: mainVC!, countries: countries, location: location)
  }
  
  internal func presentHowToPlay() {
    howToPlayWireframe?.presentHowToPlayFromVC(viewController: mainVC!)
  }
  
  internal func presentCustomGame(withCountries countries: [Country]) {
    customGameWireframe?.presentCustomGameFromVC(viewController: mainVC!, countries: countries)
  }
  
  internal func presentStartNewGameVCFromMainVC() {
    
    startNewGameVC = startNewGameViewController()
    startNewGameVC?.transitioningDelegate = self
    startNewGameVC?.modalPresentationStyle = UIModalPresentationStyle.custom
    startNewGameVC?.mainInteractor = mainInteractor
    mainInteractor?.startNewGameVCInterface = startNewGameVC
    
    mainVC!.navigationController!.present(startNewGameVC!, animated: true, completion: nil)
  }
  
  internal func gameCompleted(game: Game) {
    mainVC?.populateGames(game: game)
  }
  
  internal func retryGame(game: Game) {
    mainVC?.populateGames(game: game)
  }
  
  internal func presentGameInterface(withGame game: Game) {
    //dismisses startNewGameVC
    mainVC?.dismiss(animated: true, completion: nil)
    
    gameWireframe?.presentGameInterfaceFromViewController(viewController: mainVC!, withGame: game)
  }
  
  internal func presentCustomGameInterface(withGame game: Game) {
    gameWireframe?.presentGameInterfaceFromViewController(viewController: mainVC!, withGame: game)
  }

  internal func presentMainVCInterfaceFromWindow(window: UIWindow) {
    
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
  
  
  //MARK: - PRIVATE FUNCTIONS

  private func mainVCFromStoryboard() -> MainVC {
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! MainVC
    return viewController
  }
  
  private func startNewGameViewController() -> StartNewGameVC {
    let storyboard = mainStoryboard()
    let startNewGameVC = storyboard.instantiateViewController(withIdentifier: "startNewGameVC") as! StartNewGameVC
    return startNewGameVC
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
