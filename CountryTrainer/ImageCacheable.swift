//
//  ImageCacheable.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 20/07/2017.
//  Copyright © 2017 Ben Sullivan. All rights reserved.
//

import UIKit

enum ImageSize {
  case small, large
}

protocol ImageCacheable: ImageResizeable {
  func cacheImage(_ country: Array<Any>.Index, width: CGFloat, size: ImageSize)
  var countries: [Country] { get }
  var imageCache: NSCache<NSString, UIImage> { get }
}

extension ImageCacheable {
  
  func cacheImage(_ country: Array<Any>.Index, width: CGFloat, size: ImageSize) {
    
    let flag = countries[country].flag as! NSString
    
    guard imageCache.object(forKey: "\(flag)-1" as NSString) == nil else { return }
    guard imageCache.object(forKey: flag) == nil else { return }
    
    let imageStr = size == .small ? countries[country].flagSmall : countries[country].flag
    let image = UIImage(named: imageStr) ?? UIImage(named: countries[country].flag)!
    
    let smallImage = resizeImage(image: image, newWidth: width)
    imageCache.setObject(smallImage, forKey: imageStr as NSString)
    
  }
}
