//
//  FilterFlagsPresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class FilterFlagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDataSourcePrefetching, FilterFlagTableViewCellDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var numberOfMemorisedFlags: UILabel!
  
  //True = Viewing remaining countries. False = Viewing memorised countries
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
  
  var imageCache: NSCache<NSString, UIImage> {
    return filterFlagsInteractor?.imageCache ?? NSCache<NSString, UIImage>()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 10.0, *) {
      collectionView.prefetchDataSource = self
    }
    
    setProgressBar()
    
    configureCellSize()
    
    segmentedControl.changeTitleFont(newFontName: "Lato-Light", newFontSize: 14)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    filterFlagsInteractor?.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
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
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
    filterFlagsInteractor?.populateCacheFromPrefetch(isRemainingCountry: isRemainingCountry, indexPaths: indexPaths)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentCountries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterFlagsCell", for: indexPath) as! FilterFlagsCollectionViewCell
    
    print(remainingCountries[indexPath.row])
    
    let flagObjectKey = isRemainingCountry
      ? remainingCountries[indexPath.row].flagSmall as! NSString
      : memorisedCountries [indexPath.row].flagSmall as! NSString
    
    let cachedImage: UIImage? = imageCache.object(forKey: flagObjectKey) ?? nil
    cell.filterFlagDelegate = self
    
    cell.configureView(country: currentCountries[indexPath.row], isRemainingCountry: isRemainingCountry, cachedImage: cachedImage)
    
    return cell
  }
  
}
