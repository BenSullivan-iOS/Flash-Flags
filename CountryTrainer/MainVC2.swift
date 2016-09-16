////
////  ViewController.swift
////  CountryTrainer
////
////  Created by Ben Sullivan on 11/08/2016.
////  Copyright © 2016 Ben Sullivan. All rights reserved.
////
//
//import UIKit
//import pop
//
//class MainVC: UIViewController, MainVCInterface, UITableViewDelegate, UITableViewDataSource, DataService {
//  internal func getNewGameData(numberOfFlags: Int?, continent: String?) {
//    //FIXME: delete this
//  }
//  //data service for testing
//  
//  @IBOutlet weak var flagImage: UIImageView!
//  @IBOutlet weak var newGameButton: UIButton!
//  @IBOutlet weak var tableView: COBezierTableView!
//  
//  @IBOutlet weak var flagBg: UIImageView!
//  var games = [Game]()
//  
//  func populateGames(game: Game) {
//    
//    games.append(game)
//    print(games[0].resultPercentage)
//    
//    tableView.reloadData()
//  }
//  
//  
//  var menuTitles = [
//    MenuItems.about.rawValue,
//    MenuItems.tutorial.rawValue,
//    MenuItems.filterFlags.rawValue,
//    MenuItems.startNewGame.rawValue,
//    MenuItems.quickStart.rawValue
//  ]
//  
//  var countries = [Country]()
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    guard let countryArray = createCountries() else { print("json error"); return }
//    
//    countries = countryArray
//    
//    let rect = view.bounds
//    
////        let indexPath = IndexPath(row: 2, section: 2)
////    
////        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.top)
//    
//    UIView.BezierPoints.p1 = CGPoint(x: 148, y: 0)
//    UIView.BezierPoints.p2 = CGPoint(x: 11, y: 209)
//    UIView.BezierPoints.p3 = CGPoint(x: 18, y: 308)
//    UIView.BezierPoints.p4 = CGPoint(x: 163, y: 568)
//    
//  }
//  
//  override func viewDidAppear(_ animated: Bool) {
//    
//    self.flagBg.center = CGPoint(x: self.flagBg.center.x - 500, y: self.flagBg.center.y)
//    
//    UIView.animate(withDuration: 150) {
//      
//      self.flagBg.center = CGPoint(x: self.flagBg.center.x + 2000, y: self.flagBg.center.y)
//      //      self.flagBg.frame = CGRect(x: self.flagBg.center.x, y: self.flagBg.center.y + 2000, width: self.flagBg.frame.width, height: self.flagBg.frame.height)
//    }
//    
//    //    var indexPath = IndexPath(row: 5, section: 0)
//    //
//    //    tableView.scrollToRow(at: indexPath,
//    //                          at: UITableViewScrollPosition.top, animated: true)
//    
//    
//    
//        let indexPath2 = IndexPath(row: 2, section: 2)
//    
//        tableView.selectRow(at: indexPath2, animated: true, scrollPosition: UITableViewScrollPosition.top)
//  }
//  
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 3
//  }
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    
//    switch section {
//    case 0:
//      return menuTitles.count
//    case 1:
//      return games.count
//    case 2:
//      return 3
//      
//    default: break
//    }
//    if section == 0 {
//      
//      return menuTitles.count
//    }
//    return games.count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    
//    if indexPath.section == 0 {
//      
//      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
//      
//      cell.configureCell(title: menuTitles[indexPath.row])
//      cell.mainInteractor = mainInteractor
//      cell.mainWireframe = mainWireframe
//      
//      return cell
//      
//    } else if indexPath.section == 1 {
//      
//      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
//      
//      cell.configureCell(game: games[indexPath.row])
//      
//      //      cell.button?.setImage(UIImage(named: countries[indexPath.row].flag), for: .normal)
//      
//      return cell
//    }
//    
//    let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell")!
//    
//    return cell
//    
//  }
//  
//  var mainInteractor: MainInteractorInterface?
//  var mainWireframe: MainWireframe?
//  
//  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
//    mainInteractor?.getNewGameData(numberOfFlags: 5, continent: nil)
//    
//  }
//  
//  func prepareGameData(game: Game) {
//    
//    mainWireframe?.presentGameInterface(withGame: game)
//  }
//}
