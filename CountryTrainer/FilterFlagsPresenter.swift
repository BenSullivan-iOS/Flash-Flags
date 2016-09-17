//
//  FilterFlagsPresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DataService, FilterFlagDelegate {
  
  var countries = [Country]()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let countryArray = createCountries() else { print("json error"); return }
    
    countries = countryArray
  }
  
  func removeFlagButtonPressed(country: Country) {
    
    for i in countries.indices {
      
      if countries[i] == country {
        
        countries.remove(at: i)
        collectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
        break
        
      }
    }
  }

  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return countries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterFlagsCell", for: indexPath) as! FilterFlagsCollectionViewCell
    
    cell.filterFlagDelegate = self
    cell.configureView(country: countries[indexPath.row])
    
    return cell
  }
  
}
