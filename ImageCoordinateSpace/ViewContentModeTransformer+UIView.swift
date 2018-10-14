//
//  ContentAdjustment.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

extension UIView {
    var viewContentModeTransformer: ViewContentModeTransformer  {
        get {
            return ViewContentModeTransformer(boundsSize: bounds.size,
                                              contentSize: intrinsicContentSize,
                                              contentMode: contentMode)
        }
    }
}

extension ViewContentModeTransformer {
    func transform() -> CGAffineTransform {
        return boundsSize == contentSize ? CGAffineTransform.identity : contentToViewTransform()
    }

    func transformingToSpace(_ space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: transform,
            destination: space
        )
    }
}
