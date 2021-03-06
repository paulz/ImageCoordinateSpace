//
//  Converter.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/11/19.
//

struct Converter {
    let transform: CGAffineTransform
    let reference: UICoordinateSpace

    func convert<T: Convertible>(_ object: T, to: UICoordinateSpace) -> T {
        return object.applying(transform).convert(from: reference, to: to)
    }
    func convert<T: Convertible>(_ object: T, from: UICoordinateSpace) -> T {
        return object.convert(from: from, to: reference).applying(transform.inverted())
    }
}
