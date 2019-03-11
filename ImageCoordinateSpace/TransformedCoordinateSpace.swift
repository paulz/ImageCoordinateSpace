//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

class TransformedCoordinateSpace: NSObject {
    let size: CGSize
    let transform: CGAffineTransform
    let reference: UICoordinateSpace

    lazy var invertedTransform = transform.inverted()
    lazy var bounds = CGRect(origin: .zero, size: size)

    init(size contentSize: CGSize, using: CGAffineTransform, basedOn: UICoordinateSpace) {
        reference = basedOn
        transform = using
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
