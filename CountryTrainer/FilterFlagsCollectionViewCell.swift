//
//  FilterFlagsCollectionViewCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsCollectionViewCell: UICollectionViewCell, ImageResizeable {
  
  @IBOutlet weak var flagImage: UIImageView!
  @IBOutlet weak var addRemoveImage: UIImageView!
  @IBOutlet weak var countryName: UILabel!
  @IBOutlet weak var bgView: UIView!
  
  fileprivate var country: Country?
  
  weak internal var filterFlagDelegate: FilterFlagTableViewCellDelegate?
  
  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    
    bgView.layer.cornerRadius = 5.0
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func removeButtonPressed(_ sender: UIButton) {
    
    filterFlagDelegate?.removeFlagButtonPressed(country: country!)
  }
  
  
  //MARK: - INTERNTAL FUNCTIONS
  
  internal func configureView(country: Country, isRemainingCountry: Bool, cachedImage: UIImage?) {
    
    flagImage.image = cachedImage ?? UIImage(named: country.flagSmall)
    
    addRemoveImage.image = isRemainingCountry ? #imageLiteral(resourceName: "filterFlagDeletebutton") : #imageLiteral(resourceName: "filterFlagAddButton")
    
    self.country = country
    countryName.text = country.name
    
  }
}
