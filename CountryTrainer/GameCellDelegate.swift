//
//  GameCellDelegate.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol GameCellDelegate: class {
  func answered(country: String, result: Bool)
  func retryGame()
}
