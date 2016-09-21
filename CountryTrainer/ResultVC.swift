//
//  ResultVC.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class ResultVC: UIViewController {
  
  @IBOutlet weak var menuButton: ResultButton!
  @IBOutlet weak var retryButton: ResultButton!
  var gameInteractorInterface: GameInteractorInterface?

  @IBOutlet weak var percentageLabel: UILabel!
  
  var gameWireframe: GameWireframe?
  var gameScoreString = String()
  var gameScoreInt = Int()
  var circleView: CircleView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    percentageLabel.text = gameScoreString
    
    percentageLabel.alpha = 0
    view.layer.cornerRadius = 8.0
    
    menuButton.alpha = 0
    retryButton.alpha = 0
    
    addCircleView()
    
    self.circleView.setStrokeEnd(strokeEnd: 0.0, animated: false)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    animateCircle()
    
    Timer.scheduledTimer(timeInterval: 0.4,
                         target: self,
                         selector: #selector(self.unhideButtons),
                         userInfo: nil,
                         repeats: false)
    
    self.percentageLabel.alpha = 1
    
    let velocity = NSValue(cgSize: CGSize(width: 5.0, height: 5.0))
    
    AnimationEngine.popView(view: percentageLabel, velocity: velocity)
  }
  
  func animateCircle() {
    
    let percent = Double(gameScoreInt) / 100
    let value = CGFloat(percent)
    
    self.circleView.setStrokeEnd(strokeEnd: value, animated: true)
  }
  
  @IBAction func menuButton(_ sender: AnyObject) {
    
    gameWireframe?.dismissResultVCToEndGame(game: gameInteractorInterface?.currentGame ?? Game(countries: [Country](), attempts: 0))
  }
  
  @IBAction func retryButton(_ sender: ResultButton) {
    
    gameInteractorInterface?.retryGame()
    gameWireframe?.dismissResultVCToRetry()
    
//    dismiss(animated: true, completion: nil)
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retryGame"), object: nil)
  }
  
  func dismiss(sender: AnyObject) {
    self.dismiss(animated: true, completion: { _ in })
  }
  
  func addCircleView() {
    
    let screenSize = UIScreen.main.bounds
    
    let screenCenterWidth = screenSize.width * 0.5 - 50
    let screenCenterHeight = screenSize.height * 0.5 - 170
    
    let center = CGPoint(x: screenCenterWidth, y: screenCenterHeight)
    
    let frame = CGRect(origin: center, size: CGSize(width: screenSize.width / 2, height: screenSize.width / 2))
    
    self.circleView = CircleView(frame: frame, lineWidth: 6.0)
    self.circleView.setStrokeColor(strokeColor: UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1))
    
    circleView.contentMode = .center
    
    self.circleView.center = CGPoint(x: screenCenterWidth, y: screenCenterHeight)
    
    self.view!.addSubview(self.circleView)
    
  }
  
  func unhideButtons() {
    
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))

    retryButton.alpha = 1
    AnimationEngine.popView(view: retryButton, velocity: velocity)
    
    Timer.scheduledTimer(timeInterval: 0.4,
                         target: self,
                         selector: #selector(self.unhideMenuButton),
                         userInfo: nil,
                         repeats: false)
  }
  
  func unhideMenuButton() {
    
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))

    menuButton.alpha = 1
    AnimationEngine.popView(view: menuButton, velocity: velocity)
  }
}
