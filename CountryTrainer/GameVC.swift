//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController, GameDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var progressLeading: NSLayoutConstraint!
  @IBOutlet weak var progressTrailing: NSLayoutConstraint!
  
  var gameWireframe: GameWireframe?
  var gameInteractorInterface: GameInteractorInterface?
  var selectedRow: IndexPath? = nil
  
  var game: Game? {
    return gameInteractorInterface?.currentGame ?? nil
  }
  
  var imageCache: NSCache<NSString, UIImage> {
    return gameInteractorInterface?.imageCache ?? NSCache<NSString, UIImage>()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.progressLeading.constant = self.view.frame.width / 2 + 10
    self.progressTrailing.constant = self.view.frame.width / 2 + 10
    
    navigationItem.backBarButtonItem?.responds(to: #selector(self.radialPop))
    
    navigationController?.enableRadialSwipe()
    tableView.estimatedRowHeight = 250
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showPickerView(delay: 0)
    gameInteractorInterface?.populateCache()
    
  }
  
  @IBAction func backButtonPressed(_ sender: UIButton) {
    radialPop()
  }
  
  
  func showPickerView(delay: Double) {
    
    UIView.animate(withDuration: 1,
                   delay: delay,
                   usingSpringWithDamping: CGFloat(0.4),
                   initialSpringVelocity: CGFloat(0.1),
                   options: UIViewAnimationOptions.curveEaseInOut,
                   animations: {
                    
                    self.progressLeading.constant = 50
                    self.progressTrailing.constant = 50
                    
                    self.view.layoutIfNeeded()
                    
    }) { finished in
      print("finished")
    }
    
  }
  
  func retryGame() {
    
//    imageCache.removeAllObjects()
    
    gameInteractorInterface?.retryGame()
    
//    self.game = game
    
    self.progressView.setProgress(0, animated: false)
    
    showPickerView(delay: 0.5)
    
    tableView.reloadData()
  }
  
  func answered(country: String, result: Bool) {
    
    if game != nil {
      
      gameInteractorInterface?.answered(
        country: country,
        result: result)
      
      tableView.deleteRows(
        at: [selectedRow!],
        with: UITableViewRowAnimation.fade)
      
      if result == true {
        
        updateProgressBar()
      }
      checkForGameCompleted(game: game!)
    }
  }
  
  func updateProgressBar() {
    
    if let result = game?.resultPercentage {
      
      let pro: Float = Float(result) / 100.0
      
      UIView.animate(withDuration: 1, animations: {
        
        self.progressView.setProgress(pro, animated: true)
      })
    }
  }
  
  func checkForGameCompleted(game: Game) {
    
    if game.tracker.remainingCountries.count == 0 {
      
      let percentageString = " \(game.resultPercentage)%"
      let percentInt = game.resultPercentage
      
      gameWireframe?.presentResultInterfaceFrom(
        viewController: self,
        scoreInt: percentInt,
        scoreString: percentageString)
      
      UIView.animate(withDuration: 0.5, animations: {
        
        self.progressLeading.constant = self.view.frame.width / 2 + 10
        self.progressTrailing.constant = self.view.frame.width / 2 + 10
        
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func radialPop() {
    
    navigationController?.radialPopViewController()
  }
}
