//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

class TransformedCoordinateSpace : NSObject, UICoordinateSpace {
    let spaceSize : CGSize
    let reference : UICoordinateSpace
    let transformToReference : CGAffineTransform

    init(size:CGSize, transform:CGAffineTransform, destination:UICoordinateSpace) {
        spaceSize = size
        transformToReference = transform
        reference = destination
    }

    var bounds: CGRect {
        return CGRect(origin: CGPoint.zero, size: spaceSize)
    }

    func convert(_ point: CGPoint, to coordinateSpace: UICoordinateSpace) -> CGPoint {
        return reference.convert(
            point.applying(transformToReference),
            to: coordinateSpace
        )
    }

    func convert(_ rect: CGRect, to coordinateSpace: UICoordinateSpace) -> CGRect {
        return reference.convert(
            rect.applying(transformToReference),
            to: coordinateSpace
        )
    }

    func convert(_ point: CGPoint, from coordinateSpace: UICoordinateSpace) -> CGPoint {
        return reference.convert(point, from: coordinateSpace).applying(transformFromReference
        )
    }

    func convert(_ rect: CGRect, from coordinateSpace: UICoordinateSpace) -> CGRect {
        return reference.convert(rect, from: coordinateSpace).applying(transformFromReference
        )
    }

    fileprivate lazy var transformFromReference : CGAffineTransform = {
        return self.transformToReference.inverted()
    }()
}
