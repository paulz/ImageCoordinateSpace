//
//  Convertible.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 10/13/18.
//

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
