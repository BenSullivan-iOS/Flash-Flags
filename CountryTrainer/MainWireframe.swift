//
//  MainVCWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainWireframe {
  
  var mainVC: MainVC?
  var mainInteractor: MainInteractor?
  var gameWireframe: GameWireframe?
  var rootWireframe: RootWireframe?
  
  func presentGameInterface(withGame game: Game) {
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
}
