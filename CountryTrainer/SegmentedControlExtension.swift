//
//  SegmentedControlExtension.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 21/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension UISegmentedControl {
  
  func changeTitleFont(newFontName:String?, newFontSize:CGFloat?){
    
    let attributedSegmentFont = NSDictionary(object: UIFont(name: newFontName!, size: newFontSize!)!, forKey: NSFontAttributeName as NSCopying)
    setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], for: .normal)
  }
}
