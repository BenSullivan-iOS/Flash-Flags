//
//  ImageResizeable.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 24/09/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

protocol ImageResizeable {
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
}

extension ImageResizeable {
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}
