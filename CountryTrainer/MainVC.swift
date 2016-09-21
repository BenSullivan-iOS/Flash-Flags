//
//  ViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class MainVC: UIViewController, MainVCInterface, UITableViewDelegate, UITableViewDataSource, MenuTableViewCellDelegate {
  
  @IBOutlet weak var tableView: COBezierTableView!
  @IBOutlet weak var flagBg: UIImageView!
  
  var mainInteractor: MainInteractorInterface?
  var mainWireframe: MainWireframe?
  
  var games: [Game] {
    return mainInteractor?.games ?? [Game]()
  }
  
  var menuTitles = [
    MenuItems.about.rawValue,
    MenuItems.tutorial.rawValue,
    MenuItems.filterFlags.rawValue,
    MenuItems.startNewGame.rawValue,
    MenuItems.quickStart.rawValue
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.barStyle = UIBarStyle.black
    self.navigationController?.isNavigationBarHidden = true
    
    configureTablePath()
    setInitialTableRow()

  }
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    mainInteractor?.getNewGameData(numberOfFlags: 5, continent: nil)
  }
  
  func presentFilterFlags() {
    
    mainWireframe?.presentFilterFlagsInterface(withCountries: (mainInteractor?.countries)!)
  }
  
  func updateCountriesAfterFilter(countries: [Country]) {
    
    mainInteractor?.updateCountries(countries: countries)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
      return menuTitles.count
    case 1:
      return games.count
    case 2:
      return 3
      
    default: break
    }
    if section == 0 {
      
      return menuTitles.count
    }
    return games.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
      
      cell.menuTableViewCellDelegate = self
      cell.configureCell(title: menuTitles[indexPath.row])
      cell.mainInteractor = mainInteractor
      cell.mainWireframe = mainWireframe
      
      return cell
      
    } else if indexPath.section == 1 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
      
      
      cell.configureCell(game: games[indexPath.row])
      
      //      cell.button?.setImage(UIImage(named: countries[indexPath.row].flag), for: .normal)
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell")!
    
    return cell
    
  }
  
  func populateGames(game: Game) {
    
    mainInteractor?.populateGamesForMainVCTable(game: game)
    tableView.reloadData()
  }
  
  func prepareGameData(game: Game) {
    mainWireframe?.presentGameInterface(withGame: game)
    
  }
  
  func configureTablePath() {
    UIView.BezierPoints.p1 = CGPoint(x: 148, y: 0)
    UIView.BezierPoints.p2 = CGPoint(x: 11, y: 209)
    UIView.BezierPoints.p3 = CGPoint(x: 18, y: 308)
    UIView.BezierPoints.p4 = CGPoint(x: 163, y: 568)
  }
  
  func setInitialTableRow() {
    let indexPath = IndexPath(row: 2, section: 2)
    
    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
  }

}
