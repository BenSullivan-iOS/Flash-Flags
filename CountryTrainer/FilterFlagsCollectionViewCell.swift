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
  @IBOutlet weak var addRemoveImage: UIImageView!
  
  @IBOutlet weak var countryName: UILabel!
  @IBOutlet weak var bgView: UIView!
  
  var country: Country?
  var filterFlagDelegate: FilterFlagDelegate?
  
  override func awakeFromNib() {
    
    bgView.layer.cornerRadius = 5.0
  }
  
  @IBAction func removeButtonPressed(_ sender: UIButton) {
    
    filterFlagDelegate?.removeFlagButtonPressed(country: country!)
  }
  
  
  func configureView(country: Country, isRemainingCountry: Bool) {
    
    if flagImage.image == nil {
      flagImage.image = UIImage(named: country.flagSmall) ?? UIImage(named: country.flag)
    }
    
    addRemoveImage.image = isRemainingCountry ? #imageLiteral(resourceName: "filterFlagDeletebutton") : #imageLiteral(resourceName: "filterFlagAddButton")
    
    self.country = country
    flagImage.image = UIImage(named: country.flagSmall) ?? UIImage(named: country.flag)
    countryName.text = country.name
  }
}
