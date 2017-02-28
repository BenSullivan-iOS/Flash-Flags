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

protocol Maskable {
  func createMask(corners: UIRectCorner) -> CAShapeLayer
}

extension Maskable where Self : UILabel {
  
  func createMask(corners: UIRectCorner) -> CAShapeLayer {
    print("CREATING MASK")
    
    var maskLayer = CAShapeLayer()
    
    let circlePath = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: 20, height:  20))
    
    maskLayer = CAShapeLayer()
    maskLayer.path = circlePath.cgPath
    maskLayer.fillColor = UIColor.white.cgColor
    
    backgroundColor = .clear
    
    return maskLayer
  }
}

class TopRoundedLabel: UILabel, Maskable {
  
  static var maskLayer: CAShapeLayer? = nil
  
  override func layoutSublayers(of layer: CALayer) {
    
    let mask = createMask(corners: [.topLeft, .topRight])
    //      print(mask)
    //      dump(mask)
    
    
    TopRoundedLabel.maskLayer = mask
    layer.addSublayer(mask)
    
    mask.zPosition = 0
    
    for subview in layer.sublayers! {
      subview.zPosition = 0
      
    }
    for lay in layer.sublayers! {
      
      if lay.isKind(of: CAShapeLayer.self) {
        lay.zPosition = 0
      } else {
        lay.zPosition = 1
      }
      
    }

  }
}

class BottomLeftRoundedLabel: UILabel, Maskable {
  
  static var maskLayer: CAShapeLayer? = nil
  override func layoutSublayers(of layer: CALayer) {
    
    if let maskLayer = TopRoundedLabel.maskLayer {
      
      layer.addSublayer(createMask(corners: [.bottomLeft]))
      
    } else {
      
      layer.addSublayer(createMask(corners: [.bottomLeft]))
      
    }
  }
}

class BottomRightRoundedLabel: UILabel, Maskable {
  
  static var maskLayer: CAShapeLayer? = nil
  
  override func layoutSublayers(of layer: CALayer) {
    
    if let maskLayer = TopRoundedLabel.maskLayer {
      
      layer.addSublayer(createMask(corners: [.bottomRight]))
      
    } else {
      
      layer.addSublayer(createMask(corners: [.bottomRight]))
      
    }
    
  }
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MainVCInterface, MenuTableViewCellDelegate, UITableViewDataSourcePrefetching {
  
  var prefetchedCells = Set<MainTableViewCell>()
  
  var topMask = CAShapeLayer()
  var bottomMask = CAShapeLayer()
  
  func createMasks() {
  
    
    
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      for i in indexPaths {
        if i.section == 0 {
          return
        }
      }
      
      
      
      for i in indexPaths {
        
        for a in self.prefetchedCells {
          if self.games[i.row] == a.game! {
            return
          }
        }
        
        let isIndexValid = self.games.indices.contains(i.row)
        
        if isIndexValid {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
          DispatchQueue.main.async {
            
//            
//            let circle = CircleView(frame: CGRect(x: 8, y: 17, width: 47, height: 47), lineWidth: 2.0)
            
            cell.configureCell(game: self.games[i.row], circleView: nil)
            
            cell.mainWireframe = self.mainWireframe
            cell.mainVCInterface = self
            
            
            self.prefetchedCells.insert(cell)
            
          }
          
          
          
        }
      }
    }
    
  }
  
  //  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableView: COBezierTableView!
  @IBOutlet weak var flagBg: UIImageView!
  @IBOutlet weak var splashBackground: UIImageView!
  
  internal var mainInteractor: MainInteractorInterface?
  internal var mainWireframe: MainWireframe?
  
  fileprivate var circleViewCache = NSCache<NSString, CircleView>()

  fileprivate var games: [Game] {
    return mainInteractor?.games ?? [Game]()
  }
  
  fileprivate var menuTitles = MenuItems.all
  
  
  //MARK: - VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createMasks()
    
    if #available(iOS 10.0, *) {
      tableView.prefetchDataSource = self
    } else {
      // Fallback on earlier versions
    }
    
    switch UIDevice.current.modelName {
    case "iPod Touch 6", "iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5c":

      flagBg.alpha = 1
      
    default:
      
      if #available(iOS 10.0, *) {
//        setupGlobe()
//        flagBg.alpha = 0
      } else {
        flagBg.alpha = 1
      }
    }
    
    self.navigationController?.isNavigationBarHidden = true
    
    configureTablePath()
    setInitialTableRow()
    
    for i in games {
      
      print(i.numberOfFlags)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableViewFrameOrigin = tableView.frame
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
  
  var indexPathForCustomGame: IndexPath?
  
  //Trying to save the index path of each cell, then use rectForIndexPath whenever one of the menu buttons are pressed
  
  //MARK: - OUTLET ACTIONS
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    mainInteractor?.getNewGameData(numberOfFlags: 5, continent: nil, difficulty: Difficulty.allDifficulties.rawValue, subject: .flags)
  }
  
  @IBOutlet weak var toggleMenu: UIButton!
  
  var tableViewFrameOrigin: CGRect!

  @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
  @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
  
  @IBAction func toggleMenuToShowGlobe(_ sender: Any) {
    
    UIView.animate(withDuration: 0.4, animations: {
    
      self.tableViewLeading.constant = self.tableViewLeading.constant == 0 ? 414 : 0
      self.tableViewTrailing.constant = self.tableViewTrailing.constant == 0 ? -414 : 0
      self.scnView?.allowsCameraControl = self.scnView?.allowsCameraControl == true ? false : true

      self.view.layoutIfNeeded()

    })
    
//    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//      
//      let offScreenRect = CGRect(x: self.tableViewFrameOrigin.origin.x + 400, y: self.tableViewFrameOrigin.origin.y, width: self.tableViewFrameOrigin.width, height: self.tableViewFrameOrigin.height)
//      self.tableView.frame = self.tableView.frame != self.tableViewFrameOrigin ? self.tableViewFrameOrigin : offScreenRect
//    
//    }) { action in
//      
//      
//    }
    
  }
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func presentFilterFlags(indexPath: IndexPath) {
    
    let rect = tableView.rectForRow(at: indexPath)
    
    mainWireframe?.presentFilterFlagsInterface(withCountries: (mainInteractor?.countries)!, location: rect)
  }
  
  func presentQuickStartAlert() {
    
    let alert = UIAlertController(title: "Select subject", message: nil, preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: "Flags", style: .default, handler: { action in
      
      self.mainInteractor?.getNewGameData(
        numberOfFlags: 5,
        continent: nil,
        difficulty: Difficulty.allDifficulties.rawValue,
        subject: .flags)
      
    }))
    
    alert.addAction(UIAlertAction(title: "Capitals", style: .default, handler: { action in
      
      self.mainInteractor?.getNewGameData(
        numberOfFlags: 5,
        continent: nil,
        difficulty: Difficulty.allDifficulties.rawValue,
        subject: .capitals)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
    
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
    
    present(alert, animated: true, completion: nil)
    
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
  
  
  //MARK: - TABLE VIEW
  
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
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
      
      cell.menuTableViewCellDelegate = self
      cell.configureCell(title: menuTitles[indexPath.row], indexPath: indexPath)
      cell.mainInteractor = mainInteractor
      cell.mainWireframe = mainWireframe
      
      return cell
      
    } else if indexPath.section == 1 {
      
      for i in prefetchedCells {
        
        if i.game! == games[indexPath.row] {
          return i
        }
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
      
      
//      cell.configureCell(game: games[indexPath.row], circleView: nil)
      cell.mainWireframe = mainWireframe
      cell.mainVCInterface = self
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell")!
    
    return cell
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  
  
  
  
  
  var scnView: SCNView?

  let materialPrefixes : [String] = [
                                     "oakfloor2",
                                     "scuffed-plastic",
                                     "rustediron-streaks"];
  func setupGlobe() {
    
    if #available(iOS 10.0, *) {
      
      // create a new scene
      let scene = SCNScene(named: "sphere.obj")!
      
      // select the sphere node - As we know we only loaded one object
      // we select the first item on the children list
      let sphereNode = scene.rootNode.childNodes[0]
      
      // create and add a camera to the scene
      let cameraNode = SCNNode()
      cameraNode.camera = SCNCamera()
      scene.rootNode.addChildNode(cameraNode)
      
      // place the camera
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 10.5)
      
      let material = sphereNode.geometry?.firstMaterial
      
      // Declare that you intend to work in PBR shading mode
      // Note that this requires iOS 10 and up
      material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
      
      // Setup the material maps for your object
      let materialFilePrefix = materialPrefixes[2]
      material?.diffuse.contents = #imageLiteral(resourceName: "bkflagMapWithCaps")
      material?.roughness.contents = UIImage(named: "\(materialFilePrefix)-roughness.png")
      material?.metalness.contents = UIImage(named: "\(materialFilePrefix)-metal.png")
      
      material?.normal.contents = UIImage(named: "\(materialFilePrefix)-normal.png")
      
      // Setup background - This will be the beautiful blurred background
      // that assist the user understand the 3D envirnoment
      let bg = UIImage(named: "sphericalBlurred.png")
      scene.background.contents = bg;
      
      // Setup Image Based Lighting (IBL) map
      let env = UIImage(named: "spherical.jpg")
      scene.lightingEnvironment.contents = env
      scene.lightingEnvironment.intensity = 2.0
      
      
      // retrieve the SCNView
      scnView = self.view as! SCNView?
      
      // set the scene to the view
      scnView?.scene = scene
      
      // allows the user to manipulate the camera
      scnView?.allowsCameraControl = false
      
      
      /*
       * The following was not a part of my blog post but are pretty easy to understand:
       * To make the Orb cool, we'll add rotation animation to it
       */
      
      sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 10)))
    }
  }
}
