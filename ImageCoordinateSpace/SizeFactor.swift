//
//  SizeFactor.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/10/19.
//

import Foundation

typealias SizeFactor = CGSize

extension SizeFactor {
    init(height: ScaleFactor = .center, width: ScaleFactor = .center) {
        self.init(width: width.rawValue, height: height.rawValue)
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
        case .topRight:
            self.init(height: .top, width: .right)
        case .bottomLeft:
            self.init(height: .bottom, width: .left)
        case .bottomRight:
            self.init(height: .bottom, width: .right)
        default:
            self.init(height: .center, width: .center)
        }
    }
}
