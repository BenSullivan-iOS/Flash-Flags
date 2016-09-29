//
//  DesignableFont.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 27/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

@IBDesignable class TIFAttributedLabel: UILabel {
  
  @IBInspectable var fontSize: CGFloat = 13.0
  
  @IBInspectable var fontFamily: String = "Lato-Regular"
  
  override func awakeFromNib() {
    
    let attrString = NSMutableAttributedString(attributedString: self.attributedText!)
    
    attrString.addAttribute(NSFontAttributeName,
                            value: UIFont(
                              name: self.fontFamily,
                              size: self.fontSize)!,
                            range: NSMakeRange(0, attrString.length))
    
    self.attributedText = attrString
  }
}
