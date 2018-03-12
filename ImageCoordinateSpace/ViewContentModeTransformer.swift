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

func translateWithFactors(tx:CGFloat, ty:CGFloat, xFactor:Factor, yFactor:Factor) -> CGAffineTransform {
    return CGAffineTransform(translationX: tx * xFactor.rawValue, y: ty * yFactor.rawValue)
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

    func contentToViewTransform() -> CGAffineTransform {
        let height = contentSize.height
        let width = contentSize.width

        func translate(_ xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return translateWithScale(xFactor, yFactor, 1.0)
        }

        func translateToCenterAndScale(_ scale:CGFloat) -> CGAffineTransform {
            return translateWithScale(.half, .half, scale).scaledBy(x: scale, y: scale)
        }

        func translateWithScale(_ xFactor:Factor, _ yFactor:Factor, _ scale:CGFloat) -> CGAffineTransform {
            return translateWithFactors(
                tx: viewSize.width - width * scale,
                ty: viewSize.height - height * scale,
                xFactor: xFactor,
                yFactor: yFactor
            )
        }

        let widthRatio = viewSize.width / width
        let heightRatio = viewSize.height / height

        switch contentMode {
        case .scaleAspectFill:
            return translateToCenterAndScale(max(widthRatio, heightRatio))
        case .scaleAspectFit:
            return translateToCenterAndScale(min(widthRatio, heightRatio))
        case .scaleToFill, .redraw:
            return CGAffineTransform(scaleX: widthRatio, y: heightRatio)
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
