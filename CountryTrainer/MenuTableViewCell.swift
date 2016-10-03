//
//  MenuTableViewCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 13/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var button: UIButton!
  
  weak internal var mainInteractor: MainInteractorInterface?
  weak internal var mainWireframe: MainWireframe?
  weak var menuTableViewCellDelegate: MenuTableViewCellDelegate?
  
  fileprivate var indexPath: IndexPath?

  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    button.layer.cornerRadius = 5.0
  }
  
  
  //MARK: - CELL OUTLET FUNCTIONS
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    
    guard let title = sender.titleLabel?.text else { return }
    
    switch title {
      
    case MenuItems.quickStart.rawValue:
      mainInteractor?.getNewGameData(
        numberOfFlags: 5,
        continent: nil,
        difficulty: Difficulty.allDifficulties.rawValue)
      
    case MenuItems.startNewGame.rawValue:
      mainWireframe?.presentStartNewGameVCFromMainVC()
      
    case MenuItems.filterFlags.rawValue:
      menuTableViewCellDelegate?.presentFilterFlags(indexPath: indexPath!)
      
    case MenuItems.howToPlay.rawValue:
      menuTableViewCellDelegate?.presentHowToPlay()
      
    case MenuItems.customGame.rawValue:
      menuTableViewCellDelegate?.presentCustomGame()
      
    default: break
    }
  }

  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func configureCell(title: String, indexPath: IndexPath) {
    //FIXME: - add pop in animation
    
    self.indexPath = indexPath
    button.setTitle(title, for: .normal)
  }
  
}
