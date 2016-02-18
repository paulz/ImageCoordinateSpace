//
//  ContentCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

class ContentCoordinateSpace {
    var viewSpace : UICoordinateSpace
    var contentSize : CGSize
    var contentMode : UIViewContentMode

    init(_ view: UIView) {
        viewSpace = view
        contentSize = view.intrinsicContentSize()
        contentMode = view.contentMode
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

    func contentToBoundsTransform() -> CGAffineTransform {
        return transform(contentSize, viewSize: viewSpace.bounds.size)
    }

    func transformedSpace() -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: contentToBoundsTransform(),
            destination: viewSpace
        )
    }
}
