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
    var modalViewController = ModalViewController()
    modalViewController.transitioningDelegate = self
    modalViewController.modalPresentationStyle = UIModalPresentationStyle.custom
    
    
//    present(modalViewController, animated: true, completion: nil)
    self.navigationController!.present(modalViewController, animated: true, completion: nil)
  }
  
}

class ModalViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layer.cornerRadius = 8.0
//    view.backgroundColor = customBlueColor
    addDismissButton()
    
    self.view.backgroundColor = .white
    self.addCircleView()
    self.addSlider()
  }
  // MARK: - Private Instance methods
  
  func addDismissButton() {
    var dismissButton = UIButton(type: .system)
    dismissButton.translatesAutoresizingMaskIntoConstraints = false
    dismissButton.tintColor = .white
    dismissButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
    dismissButton.setTitle("Dismiss", for: .normal)
    dismissButton.addTarget(self, action: #selector(self.dismiss(sender:)), for: .touchUpInside)
    self.view!.addSubview(dismissButton)
    self.view!.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerX, relatedBy: .equal, toItem: self.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    self.view!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dismissButton]-|", options: [], metrics: nil, views: ["dismissButton" : dismissButton]))
  }
  
  func dismiss(sender: AnyObject) {
    self.dismiss(animated: true, completion: { _ in })
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
  
  override func viewDidAppear(_ animated: Bool) {
    
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

class CircleViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.addCircleView()
    self.addSlider()
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
