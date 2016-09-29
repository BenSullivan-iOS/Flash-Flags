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
  @IBOutlet weak var percentageLabel: UILabel!
  @IBOutlet weak var fractionLabel: UILabel!

  internal var gameInteractorInterface: GameInteractorInterface?
  internal var resultInteractor: ResultInteractor?
  internal var gameWireframe: GameWireframe?
  internal var gameScoreString = String()
  internal var gameScoreInt = Int()
  
  private var circleView: CircleView!
  
  
  //MARK: - VC LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    print(gameScoreString, gameScoreInt)
    
    animateCircle()
    
    Timer.scheduledTimer(timeInterval: 0.4,
                         target: self,
                         selector: #selector(self.unhideButtons),
                         userInfo: nil,
                         repeats: false)
    
    let velocity = NSValue(cgSize: CGSize(width: 5.0, height: 5.0))
    
    AnimationEngine.popView(view: percentageLabel, velocity: velocity)
    
    animateScore()

  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func menuButton(_ sender: AnyObject) {
    
    resultInteractor?.saveGameToCoreData(game: (gameInteractorInterface?.currentGame)!)
    
    gameWireframe?.dismissResultVCToEndGame(game: (gameInteractorInterface?.currentGame)!)
  }
  
  @IBAction func retryButton(_ sender: ResultButton) {
    
    gameInteractorInterface?.retryGame()
    gameWireframe?.dismissResultVCToRetry()
  }
  
  
  //MARK: - INTERNAL FUNCTIONS
  
  internal func unhideButtons() {
    //Displays Retry button then animates menu button after delay
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
    
    retryButton.alpha = 1
    AnimationEngine.popView(view: retryButton, velocity: velocity)
    
    Timer.scheduledTimer(timeInterval: 0.4,
                         target: self,
                         selector: #selector(self.unhideMenuButton),
                         userInfo: nil,
                         repeats: false)
  }
  
  internal func unhideMenuButton() {
    
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
    
    menuButton.alpha = 1
    AnimationEngine.popView(view: menuButton, velocity: velocity)
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  @IBAction func toggleUIButtonPressed(_ sender: UIButton) {
    
    UIView.animate(withDuration: 0.2) {
      self.fractionLabel.alpha = self.fractionLabel.alpha == 0 ? 1 : 0
      self.percentageLabel.alpha = self.percentageLabel.alpha == 0 ? 1 : 0
    }
  }
  
  private func animateScore() {
    
    UIView.animate(withDuration: 0.5, animations: {
      
      self.fractionLabel.alpha = 1
      
      }) { finished in
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.curveEaseInOut, animations: {
          
          self.fractionLabel.alpha = 0

          }, completion: { done in
            
            UIView.animate(withDuration: 0.5, animations: {
              
              self.percentageLabel.alpha = 1
              
            })
        })
    }
  }
  
  private func configureView() {
    
    fractionLabel.alpha = 0
    fractionLabel.text = gameInteractorInterface?.currentGame.resultFraction
    
    percentageLabel.text = gameScoreString
    percentageLabel.alpha = 0
    
    view.layer.cornerRadius = 8.0
    
    menuButton.alpha = 0
    retryButton.alpha = 0
    
    addCircleView()
    
    self.circleView.setStrokeEnd(strokeEnd: 0.0, animated: false, friction: nil)
  }
  
  private func animateCircle() {
    
    let percent = Double(gameScoreInt) / 100
    let value = CGFloat(percent)
    
    self.circleView.setStrokeEnd(strokeEnd: value, animated: true, friction: nil)
  }
  
  private func addCircleView() {
    
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
    self.view!.sendSubview(toBack: circleView)
//    self.circleView!.sendSubview(toBack: view!)
  }
  
  private func dismiss(sender: AnyObject) {
    self.dismiss(animated: true, completion: { _ in })
  }

}
