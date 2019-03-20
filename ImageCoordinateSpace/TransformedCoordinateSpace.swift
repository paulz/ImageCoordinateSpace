//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

class TransformedCoordinateSpace: NSObject {
    let reference: UICoordinateSpace
    lazy var transform: CGAffineTransform = {
        return getTransform()
    }()
    let getTransform: () -> CGAffineTransform
    lazy var bounds: CGRect = {
        return CGRect(origin: .zero, size: size)
    }()
    let size: CGSize
    lazy var invertedTransform = transform.inverted()

    init(size contentSize: CGSize, transform: @escaping () -> CGAffineTransform, basedOn: UICoordinateSpace) {
        reference = basedOn
        getTransform = transform
        size = contentSize
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
