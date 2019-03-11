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
    let transformer: SpaceTransformer

    lazy var bounds = CGRect(origin: .zero, size: size)

    init(size contentSize: CGSize, transformer spaceTransformer: SpaceTransformer) {
        size = contentSize
        transformer = spaceTransformer
    }
}

extension TransformedCoordinateSpace: UICoordinateSpace {
    func convert(_ object: CGPoint, to space: UICoordinateSpace) -> CGPoint {
        return transformer.convert(object: object, to: space)
    }
    func convert(_ object: CGRect, to space: UICoordinateSpace) -> CGRect {
        return transformer.convert(object: object, to: space)
    }

    func convert(_ object: CGPoint, from space: UICoordinateSpace) -> CGPoint {
        return transformer.convert(object: object, from: space)
    }
    func convert(_ object: CGRect, from space: UICoordinateSpace) -> CGRect {
        return transformer.convert(object: object, from: space)
    }
}
