//
//  UIImageView+UICoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit

public extension UIImageView {
    func imageCoordinateSpace() -> UICoordinateSpace {
        return ImageViewSpace(view: self)
    }
}
