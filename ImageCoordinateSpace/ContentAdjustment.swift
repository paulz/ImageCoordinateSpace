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

    func transformContent(toViewSize viewSize:CGSize) -> CGAffineTransform {
        let transformer = ViewContentModeTransformer(
            viewSize: viewSize,
            contentSize: contentSize,
            contentMode: contentMode
        )
        return transformer.contentToViewTransform()
    }

    func contentTransformToSize(_ size: CGSize) -> CGAffineTransform {
        return size == contentSize ? CGAffineTransform.identity : transformContent(toViewSize: size)
    }

    func transformingToSpace(_ space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentTransformToSize(space.bounds.size),
            destination: space
        )
    }
}
