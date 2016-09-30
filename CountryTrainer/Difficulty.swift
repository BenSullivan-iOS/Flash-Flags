//
//  Difficulty.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 30/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

enum Difficulty: String {
  case allDifficulties = "All Difficulties"
  case easy = "Easy"
  case medium = "Medium"
  case hard = "Hard"
  
  static let difficulties = [
    allDifficulties.rawValue,
    easy.rawValue,
    medium.rawValue,
    hard.rawValue]
}
