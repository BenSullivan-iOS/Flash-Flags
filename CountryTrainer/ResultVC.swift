//
//  ResultVC.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class CustomTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    addPresentButton()
  }
  // MARK: - UIViewControllerTransitioningDelegate
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    return PresentingAnimator()

  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissingAnimator()

  }
  
  func addPresentButton() {
    
    var presentButton = UIButton(type: .system)
    presentButton.translatesAutoresizingMaskIntoConstraints = false
    presentButton.setTitle("Present Modal View Controller", for: .normal)
    presentButton.addTarget(self, action: #selector(self.present(sender:)), for: .touchUpInside)
    
    self.view!.addSubview(presentButton)
    self.view!.addConstraint(NSLayoutConstraint(item: presentButton, attribute: .centerX, relatedBy: .equal, toItem: self.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    self.view!.addConstraint(NSLayoutConstraint(item: presentButton, attribute: .centerY, relatedBy: .equal, toItem: self.view!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
  }
  
  func present(sender: AnyObject) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "result") as! ModalViewController
//    self.present(vc, animated: true, completion: nil)
//    var modalViewController = ModalViewController()
    vc.transitioningDelegate = self
    vc.modalPresentationStyle = UIModalPresentationStyle.custom
    
    
//    present(modalViewController, animated: true, completion: nil)
    self.navigationController!.present(vc, animated: true, completion: nil)
  }
  
}

class ModalViewController: UIViewController {
  
  @IBOutlet weak var menuButton: ResultButton!
  @IBOutlet weak var retryButton: ResultButton!
  @IBOutlet weak var percentageLabel: UILabel!
  
  var circleView: CircleView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    percentageLabel.alpha = 0
    view.layer.cornerRadius = 8.0
    
    menuButton.alpha = 0
    retryButton.alpha = 0
    
    addCircleView()
    
    self.circleView.setStrokeEnd(strokeEnd: 0.0, animated: false)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    let value: CGFloat = 0.75
    self.circleView.setStrokeEnd(strokeEnd: value, animated: true)
    
    Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.unhideButtons), userInfo: nil, repeats: false)
    
    self.percentageLabel.alpha = 1
    
    let velocity = NSValue(cgSize: CGSize(width: 5.0, height: 5.0))
    
    AnimationEngine.popView(view: percentageLabel, velocity: velocity)
  }
  
  @IBAction func menuButton(_ sender: AnyObject) {
    dismiss(sender: sender)
  }
  
  func dismiss(sender: AnyObject) {
    self.dismiss(animated: true, completion: { _ in })
  }
  
  func addCircleView() {
    
    let screenSize = UIScreen.main.bounds
    
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    
    let screenCenterWidth = screenSize.width * 0.5 - 50
//    let screenCenterHeight = screenSize.height * 0.5 - 150
    let screenCenterHeight = screenSize.height * 0.5 - 170
    
    let center = CGPoint(x: screenCenterWidth, y: screenCenterHeight)
    
    let frame = CGRect(origin: center, size: CGSize(width: screenSize.width / 2 , height: screenSize.width / 2))
    
    self.circleView = CircleView(frame: frame)
    self.circleView.setStrokeColor(strokeColor: UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1))
    
    circleView.contentMode = .center
    
    self.circleView.center = CGPoint(x: screenCenterWidth, y: screenCenterHeight)
    
    self.view!.addSubview(self.circleView)
    
  }
  
  @IBAction func animateCircle(_ sender: UIButton) {
    
    let value: CGFloat = 0.75
    
    self.circleView.setStrokeEnd(strokeEnd: value, animated: true)
    
  }
  

  
  func unhideButtons() {
    
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))

    retryButton.alpha = 1
    AnimationEngine.popView(view: retryButton, velocity: velocity)
    
    Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.unhideMenuButton), userInfo: nil, repeats: false)

  }
  
  func unhideMenuButton() {
    
    let velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))

    menuButton.alpha = 1
    AnimationEngine.popView(view: menuButton, velocity: velocity)
  }
  
//  func addSlider() {
//    var slider = UISlider()
//    slider.value = 0.0
//    slider.tintColor = UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1)
//    slider.translatesAutoresizingMaskIntoConstraints = false
//    slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
//    self.view!.addSubview(slider)
//    let views = ["slider" : slider, "_circleView" : circleView] as [String : Any]
//    //NSDictionaryOfVariableBindings(slider!, circleView)
//    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_circleView]-(40)-[slider]", options: [], metrics: nil, views: views))
//    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[slider]-|", options: [], metrics: nil, views: views))
//    self.circleView.setStrokeEnd(strokeEnd: CGFloat(slider.value), animated: false)
//  }
//  
//  func sliderChanged(slider: UISlider) {
//    self.circleView.setStrokeEnd(strokeEnd: CGFloat(slider.value), animated: true)
//  }
//  
//  var dismissButton = UIButton(type: .system)
//  
//  func addDismissButton() {
//    
//    dismissButton.translatesAutoresizingMaskIntoConstraints = false
//    dismissButton.tintColor = .white
//    dismissButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
//    dismissButton.setTitle("Dismiss", for: .normal)
//    dismissButton.contentMode = .center
//    dismissButton.addTarget(self, action: #selector(self.dismiss(sender:)), for: .touchUpInside)
//    
//    self.view!.addSubview(dismissButton)
//    self.view!.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerX, relatedBy: .equal, toItem: self.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
//    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dismissButton]-|", options: [], metrics: nil, views: ["dismissButton" : dismissButton]))
//    
//    print(dismissButton.bounds)
//  }

}






class CircleViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .blue
    self.addCircleView()
//    self.addSlider()
  }
  var circleView: CircleView!
  
  func addCircleView() {
    let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    self.circleView = CircleView(frame: frame)
    self.circleView.setStrokeColor(strokeColor: UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1))
    self.circleView.center = self.view.center
    self.view!.addSubview(self.circleView)
  }
  @IBAction func animateCircle(_ sender: UIButton) {
    
    let value: CGFloat = 0.75
    
    self.circleView.setStrokeEnd(strokeEnd: value, animated: true)
    
  }
  
  func addSlider() {
    var slider = UISlider()
    slider.value = 0.0
    slider.tintColor = UIColor(colorLiteralRed: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
    self.view!.addSubview(slider)
    let views = ["slider" : slider, "_circleView" : circleView] as [String : Any]
      //NSDictionaryOfVariableBindings(slider!, circleView)
    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_circleView]-(40)-[slider]", options: [], metrics: nil, views: views))
    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[slider]-|", options: [], metrics: nil, views: views))
    self.circleView.setStrokeEnd(strokeEnd: CGFloat(slider.value), animated: false)
  }
  
  func sliderChanged(slider: UISlider) {
    self.circleView.setStrokeEnd(strokeEnd: CGFloat(slider.value), animated: true)
  }
  
  
}
