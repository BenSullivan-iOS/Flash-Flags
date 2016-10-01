//
//  CustomGamePresenter.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CustomGameVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UISearchBarDelegate, CustomGameCollectionViewCellInterface {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var chosenFlagsCollectionView: UICollectionView!
  
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  
  //True = Viewing remaining countries. False = Viewing memorised countries
  fileprivate var isRemainingCountry = true
  
  var customGameWireframe: CustomGameWireframe?
  var customGameInteractor: CustomGameInteractorInterface?
  
  var remainingCountries: [Country] {
    return customGameInteractor?.remainingCountries ?? [Country]()
  }
  
  var chosenCountries: [Country] {
    return customGameInteractor?.chosenCountries ?? [Country]()
  }
  
  var currentCountries: [Country] {
    return customGameInteractor?.countries ?? [Country]()
  }
  
  var imageCache: NSCache<NSString, UIImage> {
    return customGameInteractor?.imageCache ?? NSCache<NSString, UIImage>()
  }
  
  
  //MARK: - VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 10.0, *) {
      collectionView.prefetchDataSource = self
    }
    
    configureCellSize()
    
    resetButton.imageView?.contentMode = .scaleAspectFit
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    customGameInteractor?.populateCurrentCoutntriesCache(isRemainingCountry: isRemainingCountry)
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func resetButtonPressed(_ sender: UIButton) {
    
    displayActionSheet()
  }
  
  @IBAction func backButtonPressed(_ sender: UIButton) {
    customGameInteractor?.saveToCoreData(remainingCountries: remainingCountries)
    customGameWireframe?.dismisscustomGameVCToMainVC(withCountries: remainingCountries)
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
      
    case 0:
      isRemainingCountry = true
      customGameInteractor?.setCountries(countryArray: remainingCountries)
      
    case 1:
      isRemainingCountry = false
      customGameInteractor?.setCountries(countryArray: chosenCountries)
      
    default: break
    }
    collectionView.reloadData()
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func removeFlagButtonPressed(country: Country) {
    
    if isRemainingCountry {
      if let rowToDelete = customGameInteractor?.removeFlag(country: country) {
        collectionView.deleteItems(at: [rowToDelete])
      }
    } else {
      if let rowToDelete = customGameInteractor?.addFlag(country: country) {
        collectionView.deleteItems(at: [rowToDelete])
      }
    }
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func configureCellSize() {
    let size = UIScreen.main.bounds.width / 2 - 22
    
    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.itemSize = CGSize(width: size, height: size)
    }
  }
  
  private func resetAllRemainingFlags() {
    
    isRemainingCountry = true
    //    customGameInteractor?.setCountries(countryArray: self.remainingCountries)
    
    collectionView.reloadData()
    
    if (customGameInteractor?.resetAllFlags())! {
      collectionView.reloadData()
      
    }
  }
  
  private func displayActionSheet() {
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: "Reset all flags", style: .destructive, handler: { action in
      
      self.resetAllRemainingFlags()
      
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  
  //MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
    customGameInteractor?.populateCacheFromPrefetch(isRemainingCountry: isRemainingCountry, indexPaths: indexPaths)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == self.collectionView {
      
      return currentCountries.count
    }
    return chosenCountries.count
  }
  
  //chosenFlagsCell
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == self.collectionView {
      
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customGameCell", for: indexPath) as? CustomGameCollectionViewCell {
    
    let flagObjectKey = isRemainingCountry
      ? remainingCountries[indexPath.row].flagSmall as! NSString
      : chosenCountries [indexPath.row].flagSmall as! NSString
    
    let cachedImage: UIImage? = imageCache.object(forKey: flagObjectKey) ?? nil
    cell.customGameVCInterface = self
    
    cell.configureView(country: currentCountries[indexPath.row], isRemainingCountry: isRemainingCountry, cachedImage: cachedImage)
    
    return cell
      }
      
    } else {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chosenFlagsCell", for: indexPath) as! CustomGameChosenFlagsCell
        
        let flagObjectKey = isRemainingCountry
          ? remainingCountries[indexPath.row].flagSmall as! NSString
          : chosenCountries [indexPath.row].flagSmall as! NSString
        
        let cachedImage: UIImage? = imageCache.object(forKey: flagObjectKey) ?? nil
        cell.customGameVCInterface = self
        
        cell.configureView(country: currentCountries[indexPath.row], isRemainingCountry: isRemainingCountry, cachedImage: cachedImage)
      
        return cell
    }
    return UICollectionViewCell()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
