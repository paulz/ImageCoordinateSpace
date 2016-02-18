//
//  ImageCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

class ImageCoordinateSpace {
    var viewSpace : UICoordinateSpace
    var imageSize : CGSize?
    var contentMode : UIViewContentMode

    init(_ view: UIImageView) {
        viewSpace = view
        imageSize = view.image?.size
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

    func transformedSpace() -> UICoordinateSpace {
        let viewSize = viewSpace.bounds.size
        let contentSize = imageSize ?? viewSize
        return TransformedCoordinateSpace(
            size: contentSize,
            transform: transform(contentSize, viewSize: viewSize),
            destination: viewSpace
        )
    }
}
