//
//  FilterFlagsPresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FilterFlagDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var countries: [Country] {
    return filterFlagsInteractor?.countries ?? [Country]()
  }
  
  var filterFlagsWireframe: FilterFlagsWireframe?
  var filterFlagsInteractor: FilterFlagsInteractorInterface?
  
  @IBAction func backButtonPressed(_ sender: UIButton) {
    filterFlagsWireframe?.dismissFilterFlagsVCToMainVC(withCountries: countries)
  }
  
  func removeFlagButtonPressed(country: Country) {
    
    if let rowToDelete = filterFlagsInteractor?.removeFlag(country: country) {
      
      collectionView.deleteItems(at: [rowToDelete])
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
