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

class GameCell: UITableViewCell {
  
  @IBOutlet fileprivate weak var stackView: UIStackView!
  @IBOutlet weak var flagImage: UIImageView!
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
  
  func configureCell(_ country: Country) {
    
    flagImage.image = UIImage(named: country.flag)
    countryName.text = country.name
    
  }
  override func prepareForReuse() {
    self.stackView.arrangedSubviews[1].isHidden = true
    self.stackView.arrangedSubviews.last?.isHidden = true
  }
  
  func changeCellStatus(selected: Bool) {
    
    if selected == true {
      
      self.stackView.arrangedSubviews[1].isHidden = !selected
      self.stackView.arrangedSubviews.last?.isHidden = !selected

   } else {
      
      self.stackView.arrangedSubviews[1].isHidden = !selected
      self.stackView.arrangedSubviews.last?.isHidden = !selected
   
    }
  }

}
