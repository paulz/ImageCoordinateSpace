//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

extension UICoordinateSpace {
    public func applying(_ t: CGAffineTransform) -> UICoordinateSpace {
        return CoordinateSpaceTransformed(original: self, transform: t)
    }
}

class CoordinateSpaceTransformed : NSObject {
    let reference : UICoordinateSpace
    let transform: CGAffineTransform
    lazy var invertedTransform = transform.inverted()
    var bounds: CGRect

    init(original: UICoordinateSpace, transform applying: CGAffineTransform, bounds limitedTo: CGRect? = nil) {
        reference = original
        transform = applying
        bounds = limitedTo ?? original.bounds.applying(applying.inverted())
    }
}

extension CoordinateSpaceTransformed: UICoordinateSpace {
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

class TransformedCoordinateSpace: CoordinateSpaceTransformed {
    init(size:CGSize, transform:CGAffineTransform, destination:UICoordinateSpace) {
        super.init(original: destination, transform: transform, bounds: CGRect(origin: CGPoint.zero, size: size))
    }
}
