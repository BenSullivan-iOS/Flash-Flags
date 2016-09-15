//
//  DateExtensions.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 15/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import Foundation

extension Date {
  
  func daysBetweenDates() -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([Calendar.Component.day], from: self, to: Date())
    return components.day!
  }
}
