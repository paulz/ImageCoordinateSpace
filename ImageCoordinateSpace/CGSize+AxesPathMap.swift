//
//  CGSize+AxisPathMap.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/10/19.
//

extension CGSize {
    func axesPathMap(block: (KeyPath<CGSize, CGFloat>, CGFloat) -> CGFloat) -> CGSize {
        return .init(width: block(\.width, width),
                     height: block(\.height, height))
    }
}
