//
//  ContentCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

extension UIView {
    func contentCoordinateSpace() -> ContentCoordinateSpace {
        return ContentCoordinateSpace(contentSize: self.intrinsicContentSize(), contentMode: self.contentMode)
    }
}

class ContentCoordinateSpace {
    var contentSize : CGSize
    var contentMode : UIViewContentMode

    init(contentSize size: CGSize, contentMode mode: UIViewContentMode) {
        contentSize = size
        contentMode = mode
    }

    func transform(contentSize:CGSize, viewSize:CGSize) -> CGAffineTransform {
        if contentSize != viewSize {
            let transformer = ViewContentModeTransformer(
                viewSize: viewSize,
                contentSize: contentSize,
                contentMode: contentMode
            )
            return transformer.contentToViewTransform()
        } else {
            return CGAffineTransformIdentity
        }
    }

    func contentSizeTransform(size: CGSize) -> CGAffineTransform {
        return transform(contentSize, viewSize: size)
    }

    func transformedSpace(space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentSizeTransform(space.bounds.size),
            destination: space
        )
    }
}
