//
//  UIImage+testImage.swift
//  Unit Tests
//
//  Created by Paul Zabelin on 10/12/18.
//

import UIKit

public extension UIImage {
    static func testImage(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
