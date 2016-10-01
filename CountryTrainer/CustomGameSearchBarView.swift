//
//  CustomGameSearchBarView.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 01/10/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameSearchBarView: UISearchBar {
  
  override func awakeFromNib() {
    super.awakeFromNib()

    for i in subviews {
      
      print(i)
      
      if i.isKind(of: NSClassFromString("UISearchBarBackground")!) {
        i.backgroundColor = .white
      }
    }
  }
}
