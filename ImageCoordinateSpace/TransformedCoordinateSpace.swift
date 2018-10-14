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
    lazy var transform: CGAffineTransform = {
        return getTransform()
    }()
    let getTransform: () -> CGAffineTransform
    let bounds: CGRect
    lazy var invertedTransform = transform.inverted()

    init(original: UICoordinateSpace, transform applying: @escaping () -> CGAffineTransform, bounds limitedTo: CGRect) {
        reference = original
        getTransform = applying
        bounds = limitedTo
    }
}

extension TransformedCoordinateSpace: UICoordinateSpace {
    func convert(_ object: CGPoint, to space: UICoordinateSpace) -> CGPoint {
        return Converter(object).convert(to: space, using: self)
    }
    func convert(_ object: CGRect, to space: UICoordinateSpace) -> CGRect {
        return Converter(object).convert(to: space, using: self)
    }


    func convert(_ object: CGPoint, from space: UICoordinateSpace) -> CGPoint {
        return Converter(object).convert(from: space, using: self)
    }
    func convert(_ object: CGRect, from space: UICoordinateSpace) -> CGRect {
        return Converter(object).convert(from: space, using: self)
    }
}

extension TransformedCoordinateSpace {
    convenience init(size:CGSize, transform: @escaping () -> CGAffineTransform, destination:UICoordinateSpace) {
        self.init(original: destination, transform: transform, bounds: CGRect(origin: CGPoint.zero, size: size))
    }
}
