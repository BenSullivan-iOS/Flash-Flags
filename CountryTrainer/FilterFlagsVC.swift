//
//  FilterFlagsPresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension UISegmentedControl{
  func changeTitleFont(newFontName:String?, newFontSize:CGFloat?){
    let attributedSegmentFont = NSDictionary(object: UIFont(name: newFontName!, size: newFontSize!)!, forKey: NSFontAttributeName as NSCopying)
    setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], for: .normal)
  }
}

class FilterFlagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FilterFlagDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var numberOfMemorisedFlags: UILabel!

  var isRemainingCountry = true
  
  var filterFlagsWireframe: FilterFlagsWireframe?
  var filterFlagsInteractor: FilterFlagsInteractorInterface?
  
  var remainingCountries: [Country] {
    return filterFlagsInteractor?.remainingCountries ?? [Country]()
  }
  
  var memorisedCountries: [Country] {
    return filterFlagsInteractor?.memorisedCountries ?? [Country]()
  }
  
  var currentCountries: [Country] {
    return filterFlagsInteractor?.countries ?? [Country]()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setProgressBar()
    
    configureCellSize()
    
    segmentedControl.changeTitleFont(newFontName: "Lato-Light", newFontSize: 14)
  }

  @IBAction func backButtonPressed(_ sender: UIButton) {
    filterFlagsWireframe?.dismissFilterFlagsVCToMainVC(withCountries: currentCountries)
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
      
    case 0:
      isRemainingCountry = true
      filterFlagsInteractor?.setCountries(countryArray: remainingCountries)
      
    case 1:
      isRemainingCountry = false
      filterFlagsInteractor?.setCountries(countryArray: memorisedCountries)
      
    default: break
    }
    collectionView.reloadData()
  }
  
  func removeFlagButtonPressed(country: Country) {
    
    if isRemainingCountry {
      if let rowToDelete = filterFlagsInteractor?.removeFlag(country: country) {
        collectionView.deleteItems(at: [rowToDelete])
      }
    } else {
      if let rowToDelete = filterFlagsInteractor?.addFlag(country: country) {
        collectionView.deleteItems(at: [rowToDelete])
      }
    }
    numberOfMemorisedFlags.text = "\(memorisedCountries.count)"
    setProgressBar()
  }
  
  func setProgressBar() {
    
    let progress: Float = Float(self.memorisedCountries.count) / 236.0
    self.progressBar.progress = progress
  }
  
  func configureCellSize() {
    let size = UIScreen.main.bounds.width / 2 - 22
    
    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.itemSize = CGSize(width: size, height: size)
    }
  }
  
  
  //MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentCountries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterFlagsCell", for: indexPath) as! FilterFlagsCollectionViewCell
  
    cell.filterFlagDelegate = self
    cell.configureView(country: currentCountries[indexPath.row], isRemainingCountry: isRemainingCountry)
    
    return cell
  }
  
}
