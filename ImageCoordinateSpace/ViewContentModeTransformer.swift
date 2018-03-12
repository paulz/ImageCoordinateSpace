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

    func scale( value:@autoclosure ()->CGFloat) -> CGFloat {
        switch self {
        case .none:
            return 0
        case .half:
            return value() * rawValue
        case .full:
            return value()
        }
    }
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

    private lazy var sizeRatioBy = CGSize(width: viewSize.width / contentSize.width,
                                  height: viewSize.height / contentSize.height)

    private func translateWithScale(_ byX:Factor, _ byY:Factor, sizeScale scale:CGFloat) -> CGAffineTransform {
        let x = byX.scale(value: viewSize.width - contentSize.width * scale)
        let y = byY.scale(value: viewSize.height - contentSize.height * scale)
        return CGAffineTransform(translationX: x, y: y)
    }

    private func translate(_ byX:Factor, _ byY:Factor) -> CGAffineTransform {
        return translateWithScale(byX, byY, sizeScale: 1.0)
    }

    private func translateAndScale(using selectorFunction:(CGFloat,CGFloat)->CGFloat) -> CGAffineTransform {
        let scale = selectorFunction(sizeRatioBy.width, sizeRatioBy.height)
        return translateWithScale(.half, .half, sizeScale: scale).scaledBy(x: scale, y: scale)
    }

    func contentToViewTransform() -> CGAffineTransform {
        switch contentMode {
        case .scaleAspectFill:
            return translateAndScale(using: max)
        case .scaleAspectFit:
            return translateAndScale(using: min)
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
