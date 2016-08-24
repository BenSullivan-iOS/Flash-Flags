//
//  GameCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 18/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

protocol GameDelegate {
  func answered(country: String, result: Bool)
}

//@IBDesignable
class GameCell: UITableViewCell {
  
  @IBOutlet fileprivate weak var stackView: UIStackView!
  @IBOutlet weak var flagImage: FlagImageView!
  @IBOutlet weak var countryName: UILabel!
  
  var delegate: GameDelegate? = nil
  
  @IBAction func answeredCorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: true)
  }
  
  @IBAction func answeredIncorrectly(_ sender: UIButton) {
    delegate?.answered(country: countryName.text!, result: false)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    stackView.arrangedSubviews.last?.isHidden = true
    
  }
  
  override func prepareForReuse() {
    self.stackView.arrangedSubviews[1].isHidden = true
    self.stackView.arrangedSubviews.last?.isHidden = true
  }
  
  func configureCell(_ country: Country) {
    
    flagImage.image = UIImage(named: country.flag)
    countryName.text = country.name
    flagImage.animate()
  }
  

  
  func changeCellStatus(selected: Bool) {
    
//    let i = AnimationEngine(constraints: [NSLayoutConstraint])
    
    if selected == true {
      
      self.stackView.arrangedSubviews.last?.alpha = 0

      UIView.animate(withDuration: 0.5, animations: {
        
        self.stackView.arrangedSubviews.last?.alpha = 1
      })
      
      self.stackView.arrangedSubviews[1].isHidden = !selected
      self.stackView.arrangedSubviews.last?.isHidden = !selected

   } else {
      
      self.stackView.arrangedSubviews[1].isHidden = !selected
      self.stackView.arrangedSubviews.last?.isHidden = !selected
   
    }
  }

}
