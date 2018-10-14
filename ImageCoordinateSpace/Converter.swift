//
//  Converter.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 10/13/18.
//

import UIKit

protocol Convertible {
    func applying(_ t: CGAffineTransform) -> Self
    func convert(from: UICoordinateSpace, to: UICoordinateSpace) -> Self
}

extension CGRect : Convertible {
    func convert(from: UICoordinateSpace, to: UICoordinateSpace) -> CGRect {
        return from.convert(self, to: to)
    }
}
extension CGPoint : Convertible {
    func convert(from: UICoordinateSpace, to: UICoordinateSpace) -> CGPoint {
        return from.convert(self, to: to)
    }
}

struct Converter<T: Convertible> {
    let object: T

    init(_ convertible: T) {
        object = convertible
    }

    func convert(to: UICoordinateSpace, using transformed: TransformedCoordinateSpace) -> T {
        return object.applying(transformed.transform).convert(from: transformed.reference, to: to)
    }

    func convert(from: UICoordinateSpace, using transformed: TransformedCoordinateSpace) -> T {
        return object.convert(from: from, to: transformed.reference).applying(transformed.invertedTransform)
    }
}

