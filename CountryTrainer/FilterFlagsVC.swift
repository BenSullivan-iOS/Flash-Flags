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

class FilterFlagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDataSourcePrefetching, FilterFlagDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var numberOfMemorisedFlags: UILabel!
  
  var imageCache = NSCache<NSString, UIImage>()

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
    
    if #available(iOS 10.0, *) {
      collectionView.prefetchDataSource = self
    }
    
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
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

    print(indexPaths)
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        
        let flag = self.remainingCountries[i.row].flagSmall as! NSString
        
        if self.imageCache.object(forKey: flag) == nil {
          
          let imageStr = self.remainingCountries[i.row].flagSmall
          
          let image = UIImage(named: imageStr) ?? UIImage(named: self.remainingCountries[i.row].flag)
          let smallImage = self.resizeImage(image: image!, newWidth: 200)
          
          self.imageCache.setObject(smallImage, forKey: imageStr as NSString)
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentCountries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterFlagsCell", for: indexPath) as! FilterFlagsCollectionViewCell
    
    let nsstring = remainingCountries[indexPath.row].flagSmall as! NSString
    
    if let image = imageCache.object(forKey: nsstring) {
      
      cell.flagImage.image = image
    }
  
    cell.filterFlagDelegate = self
    cell.configureView(country: currentCountries[indexPath.row], isRemainingCountry: isRemainingCountry)
    
    return cell
  }
  
}
