//
//  GameCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class GameCell: UITableViewCell {
  
  @IBOutlet weak var flagImage: FlagImageView!
  @IBOutlet weak var countryName: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var correctButton: ResultButton!
  @IBOutlet weak var nopeButton: ResultButton!
  @IBOutlet weak var capital: UILabel!
  
  fileprivate var game: Game!
  
  weak internal var delegate: GameCellDelegate?
  
  enum Subviews {
    case flag, country, capital, buttons
  }
  
  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    stackView.arrangedSubviews[Subviews.buttons.hashValue].isHidden = true
  }
  
  override func prepareForReuse() {
    
    self.stackView.arrangedSubviews[Subviews.country.hashValue].isHidden = game.subject == .flags ? true : false
    self.stackView.arrangedSubviews[Subviews.buttons.hashValue].isHidden = true
    
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func answeredCorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: true)
  }
  
  @IBAction func answeredIncorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: false)
  }
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func configureCell(_ country: Country, cachedImage: UIImage?, game: Game) {
    
    self.game = game
    
    self.stackView.arrangedSubviews[Subviews.country.hashValue].isHidden = game.subject == .flags ? false : true
    
    flagImage.image = cachedImage ?? UIImage(named: country.flag)
    
    if country.name.contains(" / Romania") {
      countryName.text = game.subject == .flags ? country.name : country.name.replacingOccurrences(of: " / Romania", with: "")
    } else if country.name.contains(" / Chad") {
      countryName.text = game.subject == .flags ? country.name : country.name.replacingOccurrences(of: " / Chad", with: "")
    } else {
      countryName.text = country.name
    }
    
    capital.text = country.capital
    flagImage.animate()
    
    self.stackView.arrangedSubviews[Subviews.capital.hashValue].isHidden = true
    self.stackView.arrangedSubviews[Subviews.country.hashValue].isHidden = game.subject == .flags ? true : false

  }
  
  internal func changeCellStatus(selected: Bool) {
    
    //Called by GameVC willSelectRow
    //Shows and hides the flag name, capital and buttons
    
      if selected == true {
        
        self.stackView.arrangedSubviews.last?.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
          
          self.stackView.arrangedSubviews[Subviews.buttons.hashValue].alpha = 1
        })
        
        self.stackView.arrangedSubviews[Subviews.capital.hashValue].isHidden = game.subject == .flags ? true : !selected
        self.stackView.arrangedSubviews[Subviews.country.hashValue].isHidden =  game.subject == .flags ? !selected : false
        self.stackView.arrangedSubviews[Subviews.buttons.hashValue].isHidden = !selected
        
        let velocity = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        
        AnimationEngine.popView(view: correctButton, velocity: velocity)
        AnimationEngine.popView(view: nopeButton, velocity: velocity)
        
      } else {
        
        self.stackView.arrangedSubviews[Subviews.capital.hashValue].isHidden = game.subject == .flags ? true : !selected
        self.stackView.arrangedSubviews[Subviews.country.hashValue].isHidden = game.subject == .flags ? !selected : false
        self.stackView.arrangedSubviews[Subviews.buttons.hashValue].isHidden = !selected
      }
  }

}
