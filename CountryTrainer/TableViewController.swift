//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension UITableView {
  
  func setOffsetToBottom(animated: Bool) {
    self.setContentOffset(CGPoint(x: 0, y: contentSize.height - frame.size.height), animated: true)
  }
  
  func scrollToLastRow(animated: Bool) {
    if self.numberOfRows(inSection: 0) > 0 {
      self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0), section: 0), at: .bottom, animated: animated)
    }
  }
}

class GameVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, GameDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
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
  
  
  
  func present(scoreString: String, scoreInt: Int) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "result") as! ModalViewController
    
    //    self.present(vc, animated: true, completion: nil)
    //    var modalViewController = ModalViewController()
    vc.transitioningDelegate = self
    vc.modalPresentationStyle = UIModalPresentationStyle.custom
    
    vc.gameScoreString = scoreString
    vc.gameScoreInt = scoreInt
    
    
    //    present(modalViewController, animated: true, completion: nil)
    self.navigationController!.present(vc, animated: true, completion: nil)
  }
  
  func answered(country: String, result: Bool) {
    print("answered!", result)
    
    game?.tracker.updateTracker(country, result: result)
    
    for i in (game?.tracker.remainingCells)! where i.0 == country {
      
      _ = game?.tracker.removeRemainingCell(country: country)
      
      print(game?.tracker.remainingCells)
      
    }
    
    for a in (game?.tracker.remainingCountries.indices)! where game?.tracker.remainingCountries[a].name == country {
      game?.tracker.removeRemainingCountry(at: a)
      break
    }
    
    
    tableView.deleteRows(at: [selectedRow!], with: UITableViewRowAnimation.fade)
    
    print(game?.progress)
    
    self.title = game?.progress
    
    if game?.tracker.remainingCountries.count == 0 {
      
      if let game = game {
        
        let percentageString = " \(game.resultPercentage)%"
        let percentInt = game.resultPercentage
        present(scoreString: percentageString, scoreInt: percentInt)
      }
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
  
  //MARK: TRANSITION DELEGATE
  
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentingAnimator()
    
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()
    
  }
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
