//
//  MenuItems.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 16/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

enum MenuItems: String {
  
  case quickStart = "QUICK START"
  case startNewGame = "START NEW GAME"
  case filterFlags = "FILTER FLAGS"
  case howToPlay = "HOW TO PLAY"
  case customGame = "CUSTOM GAME"
//  case about = "ABOUT"
  
  static let all = [
    howToPlay.rawValue,
    filterFlags.rawValue,
    customGame.rawValue,
    startNewGame.rawValue,
    quickStart.rawValue,
  ]
}
