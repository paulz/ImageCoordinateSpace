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

extension CGRect: Convertible {
    func convert(from: UICoordinateSpace, to: UICoordinateSpace) -> CGRect {
        return from.convert(self, to: to)
    }
}
extension CGPoint: Convertible {
    func convert(from: UICoordinateSpace, to: UICoordinateSpace) -> CGPoint {
        return from.convert(self, to: to)
    }
}

struct Converter<T: Convertible> {
    let object: T

    init(_ convertible: T) {
        object = convertible
    }

    func convert(to: UICoordinateSpace, using transformer: SpaceTransformer) -> T {
        return object.applying(transformer.transform).convert(from: transformer.reference, to: to)
    }

    func convert(from: UICoordinateSpace, using transformer: SpaceTransformer) -> T {
        return object.convert(from: from, to: transformer.reference).applying(transformer.invertedTransform())
    }
}
