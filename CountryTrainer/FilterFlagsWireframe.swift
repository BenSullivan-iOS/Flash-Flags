//
//  FilterFlagsWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  var countries: [Country]?
  var filterFlagInteractor: FilterFlagsInteractor?
  var filterFlagsVC: FilterFlagsVC?
  var presentedViewController: UIViewController?
  var mainWireframe: MainWireframe?
  
  func presentFilterFlagsInterfaceFromViewController(viewController: UIViewController!, countries: [Country]) {
    
    self.countries = countries
    
    filterFlagInteractor = FilterFlagsInteractor(countries: countries)
        
    let newVC = filterFlagsViewController()
    newVC.transitioningDelegate = self
    newVC.filterFlagsWireframe = self
    newVC.filterFlagsInteractor = filterFlagInteractor
    newVC.navigationController?.enableRadialSwipe()
    
    filterFlagsVC = newVC
    
    viewController.navigationController?.radialPushViewController(viewController: newVC)
    
    presentedViewController = newVC
    
  }
  
  func dismissFilterFlagsVCToMainVC(withCountries countries: [Country]) {
    mainWireframe?.updateFilteredCountries(countries: countries)
    presentedViewController?.navigationController?.radialPopViewController()
    
  }
  
  func filterFlagsViewController() -> FilterFlagsVC {
    let storyboard = mainStoryboard()
    let filterFlagsVC = storyboard.instantiateViewController(withIdentifier: "filterFlags") as! FilterFlagsVC
    return filterFlagsVC
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
