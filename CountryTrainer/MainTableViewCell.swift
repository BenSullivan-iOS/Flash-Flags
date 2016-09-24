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
  
  weak internal var mainWireframe: MainWireframe?
  weak internal var mainVCInterface: MainVCInterface?
  
  fileprivate var circleView: CircleView!
  fileprivate var game: Game?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressDetected))
    
    button.addGestureRecognizer(gesture)
    
    addCircleView()
  }
  
  func longPressDetected() {
    
    mainVCInterface?.displayGameOptionsActionSheet(game: game!, title: "Would you like to delete this game?")
  }
  
  
  @IBAction func retryButtonPressed(_ sender: UIButton) {
    
    mainWireframe?.presentGameInterface(withGame: game!)
  }
  
  func configureCell(game: Game) {
    
    self.game = game
    
    self.attempts.text = String(game.attempts)
    self.percentage.text = "\(game.highestPercentage)%"
    self.daysAgo.text = String(game.dateLastCompleted.daysBetweenDates())
    self.flags.text = String(game.numberOfFlags)
    
    if let days = Int(daysAgo.text!) {
      
      self.daysAgoText.text = days == 1 ? "DAY AGO" : "DAYS AGO"
    }
        
    self.circleView.setStrokeEnd(strokeEnd: 0, animated: false, friction: nil)
  
    self.circleView.setStrokeEnd(strokeEnd: CGFloat(game.highestPercentage) / 100, animated: true, friction: 400)
    
    print(CGFloat(game.highestPercentage) / 100)
    
  }
  
  func addCircleView() {
    
    circleView = CircleView(frame: CGRect(x: 8, y: 17, width: 47, height: 47), lineWidth: 2.0)

    self.addSubview(self.circleView)
    
  }
}
