//
//  ViewContentModeTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

enum Factor : CGFloat {
    case none = 0
    case half = 0.5
    case full = 1

    static var center = Factor.half

    static var top = Factor.none
    static var bottom = Factor.full

    static var left = Factor.none
    static var right = Factor.full
}

class ViewContentModeTransformer {
    let viewSize : CGSize
    let contentSize : CGSize
    let contentMode : UIViewContentMode

    init(viewSize containerSize:CGSize, contentSize size:CGSize, contentMode mode:UIViewContentMode) {
        viewSize = containerSize
        contentSize = size
        contentMode = mode
    }

    lazy var sizeRatioBy = CGSize(width: viewSize.width / contentSize.width,
                                  height: viewSize.height / contentSize.height)

    func translateWithScale(_ byX:Factor, _ byY:Factor, sizeScale scale:CGFloat) -> CGAffineTransform {
        let x = byX.rawValue * (viewSize.width - contentSize.width * scale)
        let y = byY.rawValue * (viewSize.height - contentSize.height * scale)
        return CGAffineTransform(translationX: x, y: y)
    }

    func translate(_ byX:Factor, _ byY:Factor) -> CGAffineTransform {
        return translateWithScale(byX, byY, sizeScale: 1.0)
    }

    func translateToCenterAndScale(sizeScale scale:CGFloat) -> CGAffineTransform {
        return translateWithScale(.half, .half, sizeScale: scale).scaledBy(x: scale, y: scale)
    }

    func contentToViewTransform() -> CGAffineTransform {
        switch contentMode {
        case .scaleAspectFill:
            return translateToCenterAndScale(sizeScale: max(sizeRatioBy.width, sizeRatioBy.height))
        case .scaleAspectFit:
            return translateToCenterAndScale(sizeScale: min(sizeRatioBy.width, sizeRatioBy.height))
        case .scaleToFill, .redraw:
            return CGAffineTransform(scaleX: sizeRatioBy.width, y: sizeRatioBy.height)
        case .topLeft:
            return CGAffineTransform.identity
        case .center:
            return translate(.center, .center)
        case .left:
            return translate(.left, .center)
        case .right:
            return translate(.right, .center)
        case .topRight:
            return translate(.right, .top)
        case .bottomLeft:
            return translate(.left, .bottom)
        case .bottomRight:
            return translate(.right, .bottom)
        case .top:
            return translate(.center, .top)
        case .bottom:
            return translate(.center, .bottom)
        }
    }
}
