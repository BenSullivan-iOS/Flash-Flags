//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController, GameCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var progressLeading: NSLayoutConstraint!
  @IBOutlet weak var progressTrailing: NSLayoutConstraint!
  
  internal var selectedRow: IndexPath? = nil
  
  internal var gameWireframe: GameWireframe?
  internal var gameInteractorInterface: GameInteractorInterface?
  
  internal var game: Game? {
    return gameInteractorInterface?.currentGame ?? nil
  }
  
  internal var imageCache: NSCache<NSString, UIImage> {
    return gameInteractorInterface?.imageCache ?? NSCache<NSString, UIImage>()
  }
  
  
  //MARK: VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupProgressBar()
    setupBackButton()
    
    tableView.estimatedRowHeight = 250
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showPickerView(delay: 0)
    gameInteractorInterface?.populateCache()
    
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func backButtonPressed(_ sender: UIButton) {
    radialPop()
  }
  
  @IBAction func shuffleButtonPressed(_ sender: UIButton) {
    gameInteractorInterface?.shuffleCountries()
    tableView.reloadData()
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func retryGame() {
    
    gameInteractorInterface?.retryGame()
    
    self.progressView.setProgress(0, animated: false)
    
    showPickerView(delay: 0.5)
    
    tableView.reloadData()
  }
  
  internal func answered(country: String, result: Bool) {
    
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
  
  internal func radialPop() {
    
    let frame = CGRect(x: 0, y: 25, width: 40, height: 40)
    
    navigationController?.radialPopViewController(
      duration: 0.3,
      startFrame: frame,
      transitionCompletion: nil)
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func updateProgressBar() {
    
    if let result = game?.resultPercentage {
      
      let pro: Float = Float(result) / 100.0
      
      UIView.animate(withDuration: 1, animations: {
        
        self.progressView.setProgress(pro, animated: true)
      })
    }
  }
  
  private func checkForGameCompleted(game: Game) {
    
    if game.tracker.remainingCountries.count == 0 {
      
      let percentageString = " \(game.resultPercentage)%"
      let percentInt = game.resultPercentage
      
      gameInteractorInterface?.gameCompleted()
      
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
  
  private func showPickerView(delay: Double) {
    
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
  
  private func setupProgressBar() {
    self.progressLeading.constant = self.view.frame.width / 2 + 10
    self.progressTrailing.constant = self.view.frame.width / 2 + 10
  }
  
  private func setupBackButton() {
    navigationController?.enableRadialSwipe()
    navigationItem.backBarButtonItem?.responds(to: #selector(self.radialPop))
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
