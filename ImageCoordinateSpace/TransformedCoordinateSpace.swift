//
//  TransformedCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

class TransformedCoordinateSpace: NSObject {
    let size: CGSize
    let converter: Converter

    init(size contentSize: CGSize, converter spaceConverter: Converter) {
        size = contentSize
        converter = spaceConverter
    }
}

extension TransformedCoordinateSpace: UICoordinateSpace {
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }

    func convert(_ object: CGPoint, to space: UICoordinateSpace) -> CGPoint {
        return converter.convert(object, to: space)
    }
    func convert(_ object: CGRect, to space: UICoordinateSpace) -> CGRect {
        return converter.convert(object, to: space)
    }

    func convert(_ object: CGPoint, from space: UICoordinateSpace) -> CGPoint {
        return converter.convert(object, from: space)
    }
    func convert(_ object: CGRect, from space: UICoordinateSpace) -> CGRect {
        return converter.convert(object, from: space)
    }
}
