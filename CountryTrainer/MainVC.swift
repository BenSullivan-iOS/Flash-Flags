//
//  ViewController.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import pop

class MainVC: UIViewController, MainVCInterface {
  
  @IBOutlet weak var flagImage: UIImageView!
  @IBOutlet weak var newGameButton: UIButton!
  
  var mainInteractor: MainInteractorInterface?
  var mainWireframe: MainWireframe?

  func prepareGameData(game: Game) {
    
    mainWireframe?.presentGameInterface(withGame: game)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    flagImage.contentMode = .scaleAspectFit
    
  }
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    
    mainInteractor?.getNewGameData()
    
  }
  
}


//  @IBAction func correctAnswer(_ sender: UIButton) {
//    //    print(countries.count)
//    //    print(countries)
//    //
//    //    newGame?.tracker.updateTracker(chosenOnes[Int(arc4random_uniform(UInt32(numberOfFlagsSelected)))].name, result: true)
//
//  }

