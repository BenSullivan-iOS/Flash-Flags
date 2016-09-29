//
//  AppDependencies.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class AppDependencies {
  
  fileprivate var mainWireframe = MainWireframe()
  
  init() {
    configureDependencies()
  }
  
  internal func installRootViewControllerIntoWindow(window: UIWindow) {
    
    mainWireframe.presentMainVCInterfaceFromWindow(window: window)
  }
  
  private func configureDependencies() {
    
    let rootWireframe = RootWireframe()
    let gameWireframe = GameWireframe()
    let howToPlayWireframe = HowToPlayWireframe()
    let filterFlagsWireframe = FilterFlagsWireframe()
    
    filterFlagsWireframe.mainWireframe = mainWireframe
    
    mainWireframe.rootWireframe = rootWireframe
    mainWireframe.gameWireframe = gameWireframe
    mainWireframe.howToPlayWireframe = howToPlayWireframe
    mainWireframe.filterFlagsWireframe = filterFlagsWireframe
    
    gameWireframe.mainWireframe = mainWireframe
    
  }
}
