//
//  ContentAdjustment.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

extension UIView {
    func viewTransformer() -> ViewContentModeTransformer {
        return ViewContentModeTransformer(viewSize: bounds.size,
                                          contentSize: intrinsicContentSize,
                                          contentMode: contentMode)
    }
}

extension ViewContentModeTransformer {
    func contentSizeToBoundsSizeTransform() -> CGAffineTransform {
        return viewSize == contentSize ? CGAffineTransform.identity : contentToViewTransform()
    }

    func transformingToSpace(_ space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentSizeToBoundsSizeTransform(),
            destination: space
        )
    }
}
