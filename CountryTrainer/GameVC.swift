//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameVC: UIViewController, UIViewControllerTransitioningDelegate, GameDelegate {
  
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
    
//    navigationItem.backBarButtonItem?.action = #selector(self.radialPop)
    navigationItem.backBarButtonItem?.responds(to: #selector(self.radialPop))
//    navigationItem.backBarButtonItem.

//    navigationItem.leftBarButtonItem?.responds(to: #selector(self.radialPop))
    
//    navigationItem.leftBarButtonItem?.action = #selector(self.radialPop)
    
//      UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.radialPop))
    
    navigationController?.enableRadialSwipe()
    tableView.estimatedRowHeight = 250
    tableView.rowHeight = UITableViewAutomaticDimension
    
    self.title = "yo bro"
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.retryGame), name: NSNotification.Name(rawValue: "retryGame"), object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.endGame), name: NSNotification.Name(rawValue: "endGame"), object: nil)

    
  }
  
  func endGame() {
    //SAVE TO CORE DATA
    print("Save game to Core Data")
    game = nil
//    navigationController?.popViewController(animated: true)
    
  }
  
  func retryGame() {
    
    if let originalGame = game {
      
      let newGame = Game(countries: originalGame.countries)
      
      game = newGame
      
      tableView.reloadData()
      
    }
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
