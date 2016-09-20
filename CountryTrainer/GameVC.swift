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
  
  var gameWireframe: GameWireframe?
  var gameInteractorInterface: GameInteractorInterface?
  var selectedRow: IndexPath? = nil
  var game: Game?
  
  var imageCache = NSCache<NSString, UIImage>()
  
  var prefetchTest: UITableViewDataSourcePrefetching?
  
  func radialPop() {
    
    navigationController?.radialPopViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.preferredStatusBarStyle.rawValue = UIStatusBarStyle.lightContent
    
    navigationItem.backBarButtonItem?.responds(to: #selector(self.radialPop))
    
    navigationController?.enableRadialSwipe()
    tableView.estimatedRowHeight = 250
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  func retryGame(game: Game) {
    
    self.game = game
    
    self.progressView.setProgress(0, animated: false)
    
//    AnimationEngine.animateToPosition(
//    view: progressView,
//    position: CGPoint(x: self.progressView.center.x, y: self.progressView.center.y + 80),
//    bounciness: 10,
//    speed: CGFloat(2))
//    { anim, success in
//      
//      let velocity = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
//      AnimationEngine.popView(view: self.progressView, velocity: velocity)
//    print("anim complete")
//    }
    
    UIView.animate(withDuration: 1,
                   delay: 0.5,
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
    
    tableView.reloadData()
  }
  
  func answered(country: String, result: Bool) {
    
    if game != nil {
      
      game = gameInteractorInterface?.answered(
        game: game!,
        country: country,
        result: result)
      
      self.title = game!.progress
      
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
      
      let velocity = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
      
      AnimationEngine.popView(view: progressView, velocity: velocity)
      
      UIView.animate(withDuration: 1, animations: {
        self.progressView.setProgress(pro, animated: true)
      })
    }

  }
  
  @IBOutlet weak var progressLeading: NSLayoutConstraint!
  @IBOutlet weak var progressTrailing: NSLayoutConstraint!
  
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

        
//        self.progressView.center = CGPoint(x: self.progressView.center.x, y: self.progressView.center.y - 80)
      })
    }
  }
}
