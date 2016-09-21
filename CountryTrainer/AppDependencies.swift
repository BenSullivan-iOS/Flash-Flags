//
//  AppDependencies.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 10/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class AppDependencies {
  
  var mainWireframe = MainWireframe()
  
  init() {
    configureDependencies()
  }
  
  func installRootViewControllerIntoWindow(window: UIWindow) {
    
    mainWireframe.presentMainVCInterfaceFromWindow(window: window)
  }
  
  func configureDependencies() {
    
    let rootWireframe = RootWireframe()
    let gameWireframe = GameWireframe()
    let filterFlagsWireframe = FilterFlagsWireframe()
    
    filterFlagsWireframe.mainWireframe = mainWireframe
    
    mainWireframe.rootWireframe = rootWireframe
    mainWireframe.gameWireframe = gameWireframe
    mainWireframe.filterFlagsWireframe = filterFlagsWireframe
    
    gameWireframe.mainWireframe = mainWireframe
    
  }
}
