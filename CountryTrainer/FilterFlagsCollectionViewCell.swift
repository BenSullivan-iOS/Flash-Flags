//
//  FilterFlagsCollectionViewCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

protocol FilterFlagDelegate {
  func removeFlagButtonPressed(country: Country)
}

class FilterFlagsCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var flagImage: UIImageView!
  @IBOutlet weak var countryName: UILabel!
  
  @IBOutlet weak var bgView: UIView!
  
  var country: Country?
  var filterFlagDelegate: FilterFlagDelegate?
  
  override func awakeFromNib() {
    
    bgView.layer.cornerRadius = 5.0
    
    let SHADOW_COLOR: CGFloat = 157.0 / 255.0

    flagImage.layer.shadowColor = UIColor(red: SHADOW_COLOR,
                                          green: SHADOW_COLOR,
                                          blue: SHADOW_COLOR,
                                          alpha: 0.5).cgColor
    flagImage.layer.shadowOpacity = 0.8
    flagImage.layer.shadowRadius = 5.0
    flagImage.layer.shadowOffset = CGSize(width: 0, height: 2)
    //CGSizeMake(0.0, 2.0)
  }
  
  @IBAction func removeButtonPressed(_ sender: UIButton) {
    
    filterFlagDelegate?.removeFlagButtonPressed(country: country!)
  }
  
  
  func configureView(country: Country) {
    
    self.country = country
    flagImage.image = UIImage(named: country.flagSmall) ?? UIImage(named: country.flag)
    countryName.text = country.name
  }
}
