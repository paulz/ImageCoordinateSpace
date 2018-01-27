//
//  ContentAdjustment.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

extension UIView {
    func contentAdjustment() -> ContentAdjustment {
        return ContentAdjustment(contentSize: intrinsicContentSize, contentMode: contentMode)
    }
}

class ContentAdjustment {
    var contentSize : CGSize
    var contentMode : UIViewContentMode

    init(contentSize size: CGSize, contentMode mode: UIViewContentMode) {
        contentSize = size
        contentMode = mode
    }

    func transform(_ contentSize:CGSize, viewSize:CGSize) -> CGAffineTransform {
        if contentSize != viewSize {
            let transformer = ViewContentModeTransformer(
                viewSize: viewSize,
                contentSize: contentSize,
                contentMode: contentMode
            )
            return transformer.contentToViewTransform()
        } else {
            return CGAffineTransform.identity
        }
    }

    func contentTransformToSize(_ size: CGSize) -> CGAffineTransform {
        return transform(contentSize, viewSize: size)
    }

    func transformingToSpace(_ space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentTransformToSize(space.bounds.size),
            destination: space
        )
    }
}
