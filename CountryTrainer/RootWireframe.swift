//
//  RootWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class RootWireframe : NSObject {
  
  func showRootViewController(viewController: UIViewController, inWindow: UIWindow) {
    
    let navigationController = navigationControllerFromWindow(window: inWindow)
    navigationController.viewControllers = [viewController]
  }
  
  func navigationControllerFromWindow(window: UIWindow) -> UINavigationController {
    let navigationController = window.rootViewController as! UINavigationController
    return navigationController
  }
}
