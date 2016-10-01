//
//  CustomGameChosenFlagsCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 01/10/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameChosenFlagsCell: UICollectionViewCell {
  
  @IBOutlet weak var flagImage: UIImageView!
  @IBOutlet weak var addRemoveImage: UIImageView!
  @IBOutlet weak var bgView: UIView!
  
  fileprivate var country: Country?
  
  weak internal var customGameVCInterface: CustomGameCollectionViewCellInterface?
  
  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    
    bgView.layer.cornerRadius = 5.0
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func removeButtonPressed(_ sender: UIButton) {
    
    customGameVCInterface?.removeFlagButtonPressed(country: country!)
  }
  
  
  //MARK: - INTERNTAL FUNCTIONS
  
  internal func configureView(country: Country, isRemainingCountry: Bool, cachedImage: UIImage?) {
    
    flagImage.image = cachedImage ?? UIImage(named: country.flagSmall)
    
    addRemoveImage.image = #imageLiteral(resourceName: "filterFlagDeletebutton")
    
    self.country = country
  }
}
