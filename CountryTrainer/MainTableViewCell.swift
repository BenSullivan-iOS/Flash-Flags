//
//  MainTableCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 13/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bgLabel: UILabel!
  @IBOutlet weak var percentage: UILabel!
  @IBOutlet weak var attempts: UILabel!
  @IBOutlet weak var daysAgo: UILabel!
  @IBOutlet weak var flags: UILabel!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var daysAgoText: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var flagsText: UILabel!
  @IBOutlet weak var attemptsText: UILabel!
  
  @IBOutlet weak var topStackConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomStackConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var gameTitleStack: UIStackView!
  
  weak internal var mainWireframe: MainWireframe?
  weak internal var mainVCInterface: MainVCInterface?
  
  fileprivate var circleView: CircleView?
  fileprivate var game: Game?
  
  
  //MARK: - CELL LIFECYCLE
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    addButtonGestureRecogniser()
    addCircleView()
  }
  
  
  //MARK: - OUTLET FUNCTIONS
  
  @IBAction func retryButtonPressed(_ sender: UIButton) {
    mainWireframe?.presentGameInterface(withGame: game!)
  }
  
  
  //MARK: - INTERFACE FUNCTIONS
  
  internal func configureCell(game: Game, circleView: CircleView?) {
    
    self.game = game
    
    self.attempts.text = String(game.attempts)
    self.percentage.text = "\(game.highestPercentage)%"
    self.daysAgo.text = String(game.dateLastCompleted.daysBetweenDates())
    self.flags.text = String(game.numberOfFlags)
    
    if let title = game.customGameTitle {
      gameTitle.text = title
      gameTitle.isHidden = false
      gameTitleStack.isHidden = false

      bgLabel.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 236/255, blue: 191/255, alpha: 1.0)
      
      topStackConstraint.constant = 2
      bottomStackConstraint.constant = -4
      
    } else {
      gameTitleStack.isHidden = true
      gameTitle.isHidden = true
      bgLabel.backgroundColor = .white
      topStackConstraint.constant = 5
      bottomStackConstraint.constant = -8

    }
    
    if let days = Int(daysAgo.text!) {
      self.daysAgoText.text = days == 1 ? "DAY AGO" : "DAYS AGO"
    }
    
    flagsText.text = game.numberOfFlags == 1 ? "FLAG" : "FLAGS"
    attemptsText.text = game.attempts == 1 ? "ATTEMPT" : "ATTEMPTS"
    animateCircleView(game: game)
  }
  
  internal func longPressDetected() {
    
    mainVCInterface?.displayGameOptionsActionSheet(game: game!, title: "Would you like to delete this game?")
  }
  
  
  //MARK: - PRIVATE FUNCTIONS
  
  private func animateCircleView(game: Game) {
    
    self.circleView?.setStrokeEnd(strokeEnd: 0, animated: false, friction: nil)
    self.circleView?.setStrokeEnd(strokeEnd: CGFloat(game.highestPercentage) / 100, animated: true, friction: 400)
  }
  
  private func addButtonGestureRecogniser() {
    
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressDetected))
    button.addGestureRecognizer(gesture)
  }
  
  private func addCircleView() {
    
    circleView = CircleView(frame: CGRect(x: 8, y: 17, width: 47, height: 47), lineWidth: 2.0)
    self.addSubview(self.circleView!)
  }
}
