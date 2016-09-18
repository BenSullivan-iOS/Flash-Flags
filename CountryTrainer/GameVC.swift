//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameVC: UIViewController, GameDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var gameWireframe: GameWireframe?
  var gameInteractorInterface: GameInteractorInterface?
  var selectedRow: IndexPath? = nil
  var game: Game?
  
  func radialPop() {
    
    navigationController?.radialPopViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem?.responds(to: #selector(self.radialPop))
    
    navigationController?.enableRadialSwipe()
    tableView.estimatedRowHeight = 250
    tableView.rowHeight = UITableViewAutomaticDimension
    
    self.title = "yo bro"
    
  }
  
  func retryGame(game: Game) {
    
    self.game = game
    
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
      
      checkForGameCompleted(game: game!)
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
    }
  }
}
