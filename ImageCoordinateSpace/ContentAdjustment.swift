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
        return ContentAdjustment(contentSize: intrinsicContentSize, contentMode: contentMode, bounds: bounds)
    }
}

extension ViewContentModeTransformer {
    convenience init(_ adjustment: ContentAdjustment) {
        self.init(
            viewSize: adjustment.boundsSize,
            contentSize: adjustment.contentSize,
            contentMode: adjustment.contentMode)
    }
}

class ContentAdjustment {
    var contentSize : CGSize
    var contentMode : UIViewContentMode
    let boundsSize: CGSize

    init(contentSize size: CGSize, contentMode mode: UIViewContentMode, bounds:CGRect) {
        contentSize = size
        contentMode = mode
        boundsSize = bounds.size
    }

    private func transformContent() -> CGAffineTransform {
        return ViewContentModeTransformer(self).contentToViewTransform()
    }

    func contentTransformToSize() -> CGAffineTransform {
        return boundsSize == contentSize ? CGAffineTransform.identity : transformContent()
    }

    func transformingToSpace(_ space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentTransformToSize(),
            destination: space
        )
    }
}
