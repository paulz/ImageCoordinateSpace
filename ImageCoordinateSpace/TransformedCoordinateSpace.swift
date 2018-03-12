//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

class TransformedCoordinateSpace: NSObject {
    let reference : UICoordinateSpace
    let transform: CGAffineTransform
    lazy var invertedTransform = transform.inverted()
    let bounds: CGRect

    init(original: UICoordinateSpace, transform applying: CGAffineTransform, bounds limitedTo: CGRect) {
        reference = original
        transform = applying
        bounds = limitedTo
    }
}

extension TransformedCoordinateSpace: UICoordinateSpace {
    func convert(_ point: CGPoint, to coordinateSpace: UICoordinateSpace) -> CGPoint {
        return reference.convert(point.applying(transform), to: coordinateSpace)
    }

    func convert(_ point: CGPoint, from coordinateSpace: UICoordinateSpace) -> CGPoint {
        return reference.convert(point, from: coordinateSpace).applying(invertedTransform)
    }

    func convert(_ rect: CGRect, to coordinateSpace: UICoordinateSpace) -> CGRect {
        return reference.convert(rect.applying(transform), to: coordinateSpace)
    }

    func convert(_ rect: CGRect, from coordinateSpace: UICoordinateSpace) -> CGRect {
        return reference.convert(rect, from: coordinateSpace).applying(invertedTransform)
    }
}

extension TransformedCoordinateSpace {
    convenience init(size:CGSize, transform:CGAffineTransform, destination:UICoordinateSpace) {
        self.init(original: destination, transform: transform, bounds: CGRect(origin: CGPoint.zero, size: size))
    }
}
