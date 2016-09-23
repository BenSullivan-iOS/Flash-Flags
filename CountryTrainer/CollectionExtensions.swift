//
//  CollectionExtensions.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 21/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit

extension MutableCollection where Indices.Iterator.Element == Index {
  /// Shuffles the contents of this collection.
  mutating func shuffle() {
    let c = count
    guard c > 1 else { return }
    
    for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
      let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
      guard d != 0 else { continue }
      let i = index(firstUnshuffled, offsetBy: d)
      swap(&self[firstUnshuffled], &self[i])
    }
  }
}
