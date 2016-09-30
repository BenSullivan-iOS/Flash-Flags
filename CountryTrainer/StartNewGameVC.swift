//
//  StartNewGameVC.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 15/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

class StartNewGameVC: UIViewController, StartNewGameVCInterface, UIGestureRecognizerDelegate {
 
  @IBOutlet weak var difficultyPicker: UIPickerView!
  @IBOutlet weak var continentPicker: UIPickerView!
  @IBOutlet weak var numberOfFlagsPicker: UIPickerView!
  
  @IBOutlet var fullView: UIView!
  
  fileprivate var tapBGGesture: UITapGestureRecognizer!
  
  //Default settings
  internal var selectedContinent = Continent.all.rawValue
  internal var selectedNumOfFlags = 5
  internal var selectedDifficulty = Difficulty.allDifficulties.rawValue
  
  internal var continents = [Continent.all.rawValue]
  internal var difficulties = Difficulty.difficulties
  internal var numberOfFlags = [Int]()
  
  internal var mainInteractor: MainInteractorInterface?

  
  //MARK: - VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGestureRecogniser()
    getPickerData()
    
    view.layer.cornerRadius = 8.0
  }
  
  
  //MARK: - OUTLET FUNCTIONS

  @IBAction func startGameButtonPressed(_ sender: UIButton) {
    mainInteractor?.getNewGameData(numberOfFlags: selectedNumOfFlags, continent: selectedContinent, difficulty: selectedDifficulty)
    
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func displayAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Thanks! 😍", style: .default, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func getPickerData() {
    
    if let contData = mainInteractor?.prepareContinentsForPicker(),
      let flagData = mainInteractor?.prepareNumberOfFlagsForPicker() {
      
      continents += contData
      numberOfFlags += flagData
    }
  }
  
  
  //MARK: - DISMISS GESTURE RECOGNISER
  //Dismisses VC on tap outside of frame
  
  func setupGestureRecogniser() {
    
    tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(StartNewGameVC.settingsBGTapped(sender:)))
    tapBGGesture.delegate = self
    tapBGGesture.numberOfTapsRequired = 1
    tapBGGesture.cancelsTouchesInView = false
        
    ad.window?.addGestureRecognizer(tapBGGesture)
  }
  
  func settingsBGTapped(sender: UITapGestureRecognizer) {
    
    if sender.state == UIGestureRecognizerState.ended {
      
      guard let presentedView = fullView else {
        return
      }
      
      if !presentedView.bounds.contains(sender.location(in: presentedView)) {
        
        dismiss(animated: true, completion: nil)
      }
    }
  }
}
