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
        return CGRect(origin: CGPointZero, size: spaceSize)
    }

    func convertPoint(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return reference.convertPoint(
            CGPointApplyAffineTransform(point, transformToReference),
            toCoordinateSpace: coordinateSpace
        )
    }

    func convertRect(rect: CGRect, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return reference.convertRect(
            CGRectApplyAffineTransform(rect, transformToReference),
            toCoordinateSpace: coordinateSpace
        )
    }

    func convertPoint(point: CGPoint, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return CGPointApplyAffineTransform(
            reference.convertPoint(point, fromCoordinateSpace: coordinateSpace),
            transformFromReference
        )
    }

    func convertRect(rect: CGRect, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return CGRectApplyAffineTransform(
            reference.convertRect(rect, fromCoordinateSpace: coordinateSpace),
            transformFromReference
        )
    }

    private lazy var transformFromReference : CGAffineTransform = {
        return CGAffineTransformInvert(self.transformToReference)
    }()
}