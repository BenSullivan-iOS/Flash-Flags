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
  @IBOutlet weak var chosenFlagsBottomConstraint: NSLayoutConstraint!
  
  //True = Viewing remaining countries. False = Viewing memorised countries
  fileprivate var isRemainingCountry = true
  fileprivate var game: Game?
  
  internal var customGameWireframe: CustomGameWireframe?
  internal var customGameInteractor: CustomGameInteractorInterface?
  
  private var remainingCountries: [Country] {
    return customGameInteractor?.remainingCountries ?? [Country]()
  }
  
  private var chosenCountries: [Country] {
    return customGameInteractor?.chosenCountries ?? [Country]()
  }
  
  private var imageCache: NSCache<NSString, UIImage> {
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
  
 
  @IBAction func completedButtonPressed(_ sender: UIButton) {
    displayAlert()
  }
  
  @IBAction func backButtonPressed(_ sender: UIButton) {

//    customGameWireframe?.dismisscustomGameVCToMainVC(withCountries: remainingCountries)
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func moveFlagButtonPressed(country: Country, remove: Bool) {
    
   
    //true = remove from custom game. false = add to custom game
    if !remove {
      
      if let rowToDelete = customGameInteractor?.removeFlag(country: country) {
        collectionView.deleteItems(at: [rowToDelete])
        let indexPath = IndexPath(row: 0, section: 0)
        chosenFlagsCollectionView.insertItems(at: [indexPath])
      }
    } else {
      
      if let rowToAdd = customGameInteractor?.addFlag(country: country) {
        chosenFlagsCollectionView.deleteItems(at: [rowToAdd])
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
      }
      
    }
    
    if chosenFlagsBottomConstraint.constant == -115 && !chosenCountries.isEmpty {
      
      animateUIOnToScreen()
      
    } else if chosenCountries.isEmpty {
      
      animateUIOffScreen()
      
    }
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func configureCellSize() {
    let size = UIScreen.main.bounds.width / 2 - 22
    
    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.itemSize = CGSize(width: size, height: size)
    }
  }
  
  private func displayAlert() {
    
    let alert = UIAlertController(title: "Name your game", message: nil, preferredStyle: .alert)
    
    alert.addTextField { (textfield) in
      textfield.placeholder = "e.g. Scandinavia, British Territories etc..."
    }

    alert.addAction(UIAlertAction(title: "Start Game", style: .default, handler: { action in
      
      for textfield in alert.textFields! {
        
        print(textfield.text)
        
        self.game = Game(
          countries: self.chosenCountries,
          attempts: 0,
          dateLastCompleted: nil,
          highestPercentage: nil,
          dateCreated: nil,
          customGameTitle:
          textfield.text)
        
        self.customGameWireframe?.beginGame(game: self.game!)
      }
      
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

    present(alert, animated: true, completion: nil)
  }
  
  private func animateUIOnToScreen() {
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: CGFloat(1),
      initialSpringVelocity: CGFloat(0.1),
      options: UIViewAnimationOptions.curveEaseInOut,
      animations: {
        
        self.chosenFlagsBottomConstraint.constant = 0
        
        self.view.layoutIfNeeded()
        
    })
  }
  
  private func animateUIOffScreen() {
    
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: CGFloat(1),
      initialSpringVelocity: CGFloat(0.1),
      options: UIViewAnimationOptions.curveEaseInOut,
      animations: {
        
        self.chosenFlagsBottomConstraint.constant = -115
        
        self.view.layoutIfNeeded()
        
    })
    
  }

  
  
  //MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
    customGameInteractor?.populateCacheFromPrefetch(isRemainingCountry: isRemainingCountry, indexPaths: indexPaths)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == self.collectionView {
      
      return remainingCountries.count
    }
    return chosenCountries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == self.collectionView {
      
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customGameCell", for: indexPath) as? CustomGameCollectionViewCell {
        
        let flagObjectKey = isRemainingCountry
          ? remainingCountries[indexPath.row].flagSmall as! NSString
          : chosenCountries [indexPath.row].flagSmall as! NSString
        
        let cachedImage: UIImage? = imageCache.object(forKey: flagObjectKey) ?? nil
        cell.customGameVCInterface = self
        
        cell.configureView(country: remainingCountries[indexPath.row], isRemainingCountry: isRemainingCountry, cachedImage: cachedImage)
        
        return cell
      }
      
    } else {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chosenFlagsCell", for: indexPath) as! CustomGameChosenFlagsCell
      
      cell.customGameVCInterface = self
      cell.configureView(country: chosenCountries[indexPath.row], cachedImage: nil)
      
      return cell
    }
    return UICollectionViewCell()
  }
  
  internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.view.endEditing(true)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
