//
//  MainTableCell.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 13/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

class CurvedLabel: UILabel {
  
  override func awakeFromNib() {
    layer.cornerRadius = 5.0
//    layer.borderColor = UIColor.lightGray.cgColor
//    layer.borderWidth = 1.0
    backgroundColor = UIColor.blue
  }
}

class MainTableViewCell: UITableViewCell {
  
  var circleView: CircleView!

  @IBOutlet weak var bgLabel: UILabel!
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var blueEffect: UIVisualEffectView!
  
  @IBOutlet weak var percentage: UILabel!
  @IBOutlet weak var attempts: UILabel!
  @IBOutlet weak var daysAgo: UILabel!
  @IBOutlet weak var flags: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
//    bgLabel.layer.borderColor = UIColor.lightGray.cgColor
//    bgLabel.layer.borderWidth = 1.0
//    bgLabel.layer.cornerRadius = 5.0
    
    
//    button?.backgroundColor = UIColor.randomColor()
//    backgroundColor = .clear
//    button?.layer.cornerRadius = 5.0
////    self.circleView.setStrokeColor(strokeColor: UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1))
//    circleView.contentMode = .center
//
//    circleView.animateToStrokeEnd(strokeEnd: 0.75)
    
    addCircleView()
  }
  
  func configureCell(game: Game) {
    
    self.attempts.text = String(game.attempts)
    self.percentage.text = "\(game.resultPercentage)%"
    self.daysAgo.text = String(game.dateLastCompleted.daysBetweenDates())
    self.flags.text = String(game.numberOfFlags)
    self.circleView.setStrokeEnd(strokeEnd: 0, animated: false)
    
    let percent = Float(game.resultPercentage) / 100.0
    print(percent)
    
    self.circleView.setStrokeEnd(strokeEnd: CGFloat(percent), animated: true)
    
  }
  
  override func prepareForReuse() {
    
    self.circleView.setStrokeEnd(strokeEnd: 0, animated: false)
    self.circleView.setStrokeEnd(strokeEnd: 0.75, animated: true)
    
  }
  
  func addCircleView() {
    
    circleView = CircleView(frame: CGRect(x: 8, y: 17, width: 47, height: 47), lineWidth: 2.0)

    self.addSubview(self.circleView)
    
  }
}

// MARK: Random Color

extension UIColor {
  
  static func randomColor() -> UIColor {
    let randomRed: CGFloat = CGFloat(drand48())
    let randomGreen: CGFloat = CGFloat(drand48())
    let randomBlue: CGFloat = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
  }
}
