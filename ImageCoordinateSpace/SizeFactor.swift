//
//  SizeFactor.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/10/19.
//

import Foundation

struct SizeFactor {
    var width: ScaleFactor
    var height: ScaleFactor

    init(height: ScaleFactor = .center, width: ScaleFactor = .center) {
        self.width = width
        self.height = height
    }

    init(_ mode: UIView.ContentMode) {
        switch mode {
        case .left:
            self.init(width: .left)
        case .right:
            self.init(width: .right)
        case .top:
            self.init(height: .top)
        case .bottom:
            self.init(height: .bottom)
        case .topLeft:
            self.init(height: .top, width: .left)
        case .topRight:
            self.init(height: .top, width: .right)
        case .bottomLeft:
            self.init(height: .bottom, width: .left)
        case .bottomRight:
            self.init(height: .bottom, width: .right)
        default:
            self.init()
        }
    }
}
