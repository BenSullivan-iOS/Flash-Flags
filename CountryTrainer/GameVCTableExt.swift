//
//  GameVCTableExt.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 12/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension GameVC: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  // MARK: - TABLE VIEW
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
    print(indexPaths)
    
      DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        
        for i in indexPaths {
          
          print(i.row)
          print(self.game?.tracker.remainingCountries.count)
          
          let flag = self.game?.tracker.remainingCountries[i.row].flag as! NSString
          
          if self.imageCache.object(forKey: flag) == nil {
            
            let imageStr = self.game?.tracker.remainingCountries[i.row].flag
            
            let image = UIImage(named: imageStr!)
            let smallImage = self.resizeImage(image: image!, newWidth: 500)
            
            self.imageCache.setObject(smallImage, forKey: imageStr! as NSString)
          }
        }
      }
    }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    if #available(iOS 10.0, *) {
      tableView.prefetchDataSource = self
    }
    
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 80
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
    let newView = view as! UITableViewHeaderFooterView
    newView.alpha = 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameCell
      
      cell.delegate = self
      
      let nsstring = game?.tracker.remainingCountries[indexPath.row].flag as! NSString
      
      if let image = imageCache.object(forKey: nsstring) {
        
        cell.flagImage.image = image
      }
      
      cell.configureCell((game?.tracker.remainingCountries[(indexPath as NSIndexPath).row])!)
      
      return cell
      
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "gamePlaceholderCell", for: indexPath)
    
    return cell
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == 0 {
      selectedRow = indexPath
      let cell = tableView.cellForRow(at: indexPath) as! GameCell
      
      DispatchQueue.main.async {
        
        cell.changeCellStatus(selected: true)
        tableView.beginUpdates()
        tableView.endUpdates()
      }
    }
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      guard let game = game else { return 0 }
      
      return game.tracker.remainingCells.count
    }
    return 1
  }
  
}
