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
  
  weak internal var delegate: GameCellDelegate?
  
  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    stackView.arrangedSubviews.last?.isHidden = true
  }
  
  override func prepareForReuse() {
    self.stackView.arrangedSubviews.first?.isHidden = true
    self.stackView.arrangedSubviews.last?.isHidden = true
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func answeredCorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: true)
  }
  
  @IBAction func answeredIncorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: false)
  }
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func configureCell(_ country: Country, cachedImage: UIImage?) {
    
    flagImage.image = cachedImage ?? UIImage(named: country.flag)

    countryName.text = country.name
    flagImage.animate()
  }
  
  internal func changeCellStatus(selected: Bool) {
    
    //Called by GameVC willSelectRow
    //Shows and hides the flag name and buttons
    
    if selected == true {
      
      self.stackView.arrangedSubviews.last?.alpha = 0
      self.stackView.arrangedSubviews.first?.alpha = 0

      UIView.animate(withDuration: 0.5) {
        
        self.stackView.arrangedSubviews.last?.alpha = 1
        self.stackView.arrangedSubviews.first?.alpha = 1
      }
      
      self.stackView.arrangedSubviews.first?.isHidden = !selected
      self.stackView.arrangedSubviews.last?.isHidden = !selected
      
      let velocity = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))

      AnimationEngine.popView(view: correctButton, velocity: velocity)
      AnimationEngine.popView(view: nopeButton, velocity: velocity)

   } else {
      
        self.stackView.arrangedSubviews.first?.isHidden = !selected
        self.stackView.arrangedSubviews.last?.isHidden = !selected
    }
  }

}
