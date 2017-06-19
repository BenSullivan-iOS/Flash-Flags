//
//  ViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import pop

class MainVC: UIViewController, MainVCInterface, MenuTableViewCellDelegate {
  
  @IBOutlet weak var tableView: COBezierTableView!
  @IBOutlet weak var flagBg: UIImageView!
  @IBOutlet weak var splashBackground: UIImageView!
  @IBOutlet weak var toggleMenu: UIButton!
  @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
  @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
  
  internal var mainInteractor: MainInteractorInterface?
  internal var mainWireframe: MainWireframe?
  
  fileprivate var scnView: SCNView?
  fileprivate var menuTitles = MenuItems.all
  fileprivate var circleViewCache = NSCache<NSString, CircleView>()
  
  fileprivate var games: [Game] {
    return mainInteractor?.games ?? [Game]()
  }
  
  //MARK: - VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch UIDevice.current.modelName {
    case "iPod Touch 6", "iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5c":
      
      flagBg.alpha = 1
      
    default:
      
      if #available(iOS 10.0, *) {
        setupGlobe()
        flagBg.alpha = 0
      } else {
        flagBg.alpha = 1
      }
    }
    
    self.navigationController?.isNavigationBarHidden = true
    
    configureTablePath()
    setInitialTableRow()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { animation in
      
      self.splashBackground.alpha = 0
      
      if #available(iOS 10.0, *) {
        self.toggleMenu.alpha = 1
      }
    })
    
  }
  
  //MARK: - OUTLET ACTIONS
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    mainInteractor?.getNewGameData(numberOfFlags: 5, continent: nil, difficulty: Difficulty.allDifficulties.rawValue)
  }
  
  @IBAction func toggleMenuToShowGlobe(_ sender: Any) {
    
    UIView.animate(withDuration: 0.4, animations: {
      
      self.tableViewLeading.constant = self.tableViewLeading.constant == 0 ? 414 : 0
      self.tableViewTrailing.constant = self.tableViewTrailing.constant == 0 ? -414 : 0
      self.scnView?.allowsCameraControl = self.scnView?.allowsCameraControl == true ? false : true
      
      self.view.layoutIfNeeded()
      
    })
  }
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func presentFilterFlags(indexPath: IndexPath) {
    
    let rect = tableView.rectForRow(at: indexPath)
    
    mainWireframe?.presentFilterFlagsInterface(withCountries: (mainInteractor?.countries)!, location: rect)
  }
  
  internal func presentHowToPlay() {
    mainWireframe?.presentHowToPlay()
  }
  
  internal func presentCustomGame() {
    mainWireframe?.presentCustomGame(withCountries: (mainInteractor?.allCountries)!)
  }
  
  internal func reloadTableData() {
    tableView.reloadData()
  }
  
  internal func prepareGameData(game: Game) {
    mainWireframe?.presentGameInterface(withGame: game)
  }
  
  internal func displayGameOptionsActionSheet(game: Game, title: String) {
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
      
      self.mainInteractor?.deleteGame(game: game)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true)
    
  }
  
  internal func updateCountriesAfterFilter(countries: [Country]) {
    mainInteractor?.updateCountries(countries: countries)
  }
  
  internal func populateGames(game: Game) {
    mainInteractor?.populateGamesForMainVCTable(game: game)
    tableView.reloadData()
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func configureTablePath() {
    UIView.BezierPoints.p1 = CGPoint(x: 148, y: 0)
    UIView.BezierPoints.p2 = CGPoint(x: -52, y: 233)
    UIView.BezierPoints.p3 = CGPoint(x: 25, y: 308)
    UIView.BezierPoints.p4 = CGPoint(x: 200, y: 568)
  }
  
  private func setInitialTableRow() {
    
    //The table should always default to a position which displays some menu and some main cells
    
    let indexPath: IndexPath
    
    if games.count > 3 {
      indexPath = IndexPath(row: 1, section: 0)
    } else {
      indexPath = IndexPath(row: 2, section: 2)
    }
    
    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

//MARK: - TABLE VIEW
extension MainVC: UITableViewDataSource {
  
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
      
    default: return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
      
      cell.menuTableViewCellDelegate = self
      cell.configureCell(title: menuTitles[indexPath.row], indexPath: indexPath)
      cell.mainInteractor = mainInteractor
      cell.mainWireframe = mainWireframe
      
      return cell
      
    } else if indexPath.section == 1 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
      
      cell.configureCell(game: games[indexPath.row], circleView: nil)
      cell.mainWireframe = mainWireframe
      cell.mainVCInterface = self
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell")!
    
    return cell
    
  }
}

extension MainVC {
  
  func setupGlobe() {
    
    if #available(iOS 10.0, *) {
      
      let scene = SCNScene(named: "sphere.obj")!
      let sphereNode = scene.rootNode.childNodes[0]
      
      let cameraNode = SCNNode()
      cameraNode.camera = SCNCamera()
      scene.rootNode.addChildNode(cameraNode)
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 10.5)
      
      let material = sphereNode.geometry?.firstMaterial
      material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
      
      material?.diffuse.contents = #imageLiteral(resourceName: "bkflagMapWithCaps")
      material?.roughness.contents = #imageLiteral(resourceName: "rustediron-streaks-roughness")
      material?.metalness.contents = #imageLiteral(resourceName: "rustediron-streaks-metal")
      material?.normal.contents = #imageLiteral(resourceName: "rustediron-streaks-normal")
      
      let bg = #imageLiteral(resourceName: "sphericalBlurred")
      scene.background.contents = bg
      
      let env = #imageLiteral(resourceName: "spherical")
      scene.lightingEnvironment.contents = env
      scene.lightingEnvironment.intensity = 2.0
      
      scnView = self.view as! SCNView?
      scnView?.scene = scene
      scnView?.allowsCameraControl = false
      
      sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 10)))
    }
  }
}
