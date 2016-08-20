//
//  TableViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GameDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var game: Game?
  
  func answered(country: String, result: Bool) {
    print("answered!", result)
    
    game?.updateTracker(country, result: result)
    
    for i in (game?.cellTracker)! where i.0 == country {
      
      _ = game?.cellTracker.removeValue(forKey: country)
      print(game?.cellTracker)
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.estimatedRowHeight = 250
      tableView.rowHeight = UITableViewAutomaticDimension

    }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath) as! GameCell
    DispatchQueue.main.async {

    cell.changeCellStatus(selected: true)
    tableView.beginUpdates()
    tableView.endUpdates()
    }
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
        // #warning Incomplete implementation, return the number of rows
      
      guard let game = game else { return 0 }
      
        return game.cellTracker.count
    }

  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameCell

        cell.delegate = self
        cell.configureCell((game?.countries[(indexPath as NSIndexPath).row])!)
      
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
