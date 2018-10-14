//
//  ScaleFactor.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/11/18.
//

import CoreGraphics

struct SizeFactor {
    var width: ScaleFactor
    var height: ScaleFactor

    init(height: ScaleFactor = .center, width: ScaleFactor = .center) {
        self.width = width
        self.height = height
    }
}

enum ScaleFactor : CGFloat {
    case none = 0
    case half = 0.5
    case full = 1

    static var center = ScaleFactor.half

    static var top = ScaleFactor.none
    static var bottom = ScaleFactor.full

    static var left = ScaleFactor.none
    static var right = ScaleFactor.full

    func scale(value: @autoclosure () -> CGFloat) -> CGFloat {
        return self.rawValue * value()
    }
}
