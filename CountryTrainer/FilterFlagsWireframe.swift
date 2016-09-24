//
//  FilterFlagsWireframe.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsWireframe: NSObject, UIViewControllerTransitioningDelegate {
  
  fileprivate var countries: [Country]?
  fileprivate var filterFlagInteractor: FilterFlagsInteractor?
  fileprivate var filterFlagsVC: FilterFlagsVC?
  fileprivate var presentedViewController: UIViewController?
  
  var mainWireframe: MainWireframe?
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func presentFilterFlagsInterfaceFromViewController(viewController: UIViewController!, countries: [Country]) {
    
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
  
  internal func dismissFilterFlagsVCToMainVC(withCountries countries: [Country]) {
    mainWireframe?.updateFilteredCountries(countries: countries)
    
    let frame = CGRect(x: 0, y: 25, width: 40, height: 40)

    presentedViewController?.navigationController?.radialPopViewController(duration: 0.5, startFrame: frame, transitionCompletion: nil)
    
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func filterFlagsViewController() -> FilterFlagsVC {
    let storyboard = mainStoryboard()
    let filterFlagsVC = storyboard.instantiateViewController(withIdentifier: "filterFlags") as! FilterFlagsVC
    return filterFlagsVC
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
