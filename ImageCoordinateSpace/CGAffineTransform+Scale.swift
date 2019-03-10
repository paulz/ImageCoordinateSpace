//
//  CGAffineTransform+Scale.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/11/18.
//

import CoreGraphics

extension CGAffineTransform {
    var scaleX: CGFloat {
        get {
            return a
        }
    }
    var scaleY: CGFloat {
        get {
            return d
        }
    }

    init(scaleTo size: CGSize, from: CGSize) {
        self.init(scaleX: size.width / from.width,
                  y: size.height / from.height)
    }
}
