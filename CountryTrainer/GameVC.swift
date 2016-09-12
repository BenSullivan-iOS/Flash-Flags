//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class GameVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, GameDelegate {
  
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
    navigationController?.popViewController(animated: true)
    
  }
  
  func retryGame() {
    
    if let originalGame = game {
      
      let newGame = Game(countries: originalGame.countries)
      
      game = newGame
      
      tableView.reloadData()
      
    }
  }
  
  func answered(country: String, result: Bool) {

    game = gameInteractorInterface?.answered(game: game!, country: country, result: result)
    
    //Update UI
    self.title = game!.progress
    tableView.deleteRows(at: [selectedRow!], with: UITableViewRowAnimation.fade)
    
    //Display resultVC if all questions have answers
    if game!.tracker.remainingCountries.count == 0 {

        let percentageString = " \(game!.resultPercentage)%"
        let percentInt = game!.resultPercentage
        gameWireframe?.presentResultInterfaceFrom(viewController: self, scoreInt: percentInt, scoreString: percentageString)
      }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    print(indexPath.row)
    
    selectedRow = indexPath
    let cell = tableView.cellForRow(at: indexPath) as! GameCell
    
    DispatchQueue.main.async {
      
      cell.changeCellStatus(selected: true)
      tableView.beginUpdates()
      tableView.endUpdates()
    }
    
//    tableView.setContentOffset(CGPoint(x: CGFloat(0.0), y: tableView.contentSize.height - tableView.frame.size.height), animated: true)

  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    
    if let selectedIndex = tableView.indexPathForSelectedRow, selectedIndex == indexPath as IndexPath {
      
      if let cell = tableView.cellForRow(at: indexPath) as? GameCell {
        DispatchQueue.main.async {
          
          tableView.beginUpdates()
          tableView.deselectRow(at: indexPath as IndexPath, animated: true)
          cell.changeCellStatus(selected: false)
          tableView.endUpdates()
        }
      }
      
      return nil
    }
    
    return indexPath
    
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? GameCell {
      
      DispatchQueue.main.async {
        
        cell.changeCellStatus(selected: false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
      }
    }
  }
  
  // MARK: - Table view data source
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let game = game else { return 0 }
    print(game.tracker.remainingCells)
    
    return game.tracker.remainingCells.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameCell
    
    print(game?.tracker.remainingCountries)
    
    
    cell.delegate = self
    cell.configureCell((game?.tracker.remainingCountries[(indexPath as NSIndexPath).row])!)
    
    return cell
  }
  
}
