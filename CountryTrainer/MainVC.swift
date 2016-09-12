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
  
  @IBAction func newGameButtonPressed(_ sender: AnyObject) {
    mainInteractor?.getNewGameData()
  }

  func prepareGameData(game: Game) {
    mainWireframe?.presentGameInterface(withGame: game)
  }
}
