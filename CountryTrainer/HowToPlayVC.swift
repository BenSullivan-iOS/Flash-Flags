//
//  HowToPlayPresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 29/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class HowToPlayVC: UIViewController, UIViewControllerTransitioningDelegate {
  
  var howToPlayWireframe: HowToPlayWireframe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layer.cornerRadius = 8.0
  }
  
  @IBAction func doneButtonPressed(_ sender: UIButton) {
    
    howToPlayWireframe?.dismissHowToPlayVC()
    
  }
}
