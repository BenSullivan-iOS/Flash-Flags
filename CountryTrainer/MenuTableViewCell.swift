//
//  MenuTableViewCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 13/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

protocol MenuTableViewCellDelegate: class {
  func presentFilterFlags()
}

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var button: UIButton!
  
  weak var menuTableViewCellDelegate: MenuTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
        
    button.layer.cornerRadius = 5.0
//    button.layer.borderColor = UIColor.black.cgColor
//    button.layer.borderWidth = 1.0
  }
  @IBAction func buttonPressed(_ sender: UIButton) {
    
    guard let title = sender.titleLabel?.text else { return }
    
    switch title {
      
    case MenuItems.quickStart.rawValue:
      mainInteractor?.getNewGameData(numberOfFlags: 5, continent: nil)

    case MenuItems.startNewGame.rawValue:
      mainWireframe?.presentStartNewGameVCFromMainVC()
      
    case MenuItems.filterFlags.rawValue:
        menuTableViewCellDelegate?.presentFilterFlags()
    default: break
    }
    
  
  }
  
  func configureCell(title: String) {
    //add pop in animation
    button.setTitle(title, for: .normal)
  }
  
  //temp functions - move logic to VC?
  var mainInteractor: MainInteractorInterface?
  var mainWireframe: MainWireframe?
  
  
  func prepareGameData(game: Game) {
    mainWireframe?.presentGameInterface(withGame: game)
  }
}
