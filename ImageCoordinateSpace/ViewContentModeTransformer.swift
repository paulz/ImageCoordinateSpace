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
}

func translateWithFactors(tx tx:CGFloat, ty:CGFloat, xFactor:Factor, yFactor:Factor) -> CGAffineTransform {
    return CGAffineTransformMakeTranslation(tx * xFactor.rawValue, ty * yFactor.rawValue)
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

        func translate(xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return translateWithFactors(
                tx: viewSize.width - width,
                ty: viewSize.height - height,
                xFactor: xFactor,
                yFactor: yFactor
            )
        }

        let widthRatio = viewSize.width / width
        let heightRatio = viewSize.height / height

        switch contentMode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let expand = contentMode == .ScaleAspectFill
            let scale = expand ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            return CGAffineTransformScale(
                translateWithFactors(
                    tx: viewSize.width - width * scale,
                    ty: viewSize.height - height * scale,
                    xFactor: .half,
                    yFactor: .half
                ),
                scale,
                scale)
        case .ScaleToFill, .Redraw:
            return CGAffineTransformMakeScale(widthRatio, heightRatio)
        case .Center:
            return translate(.half, .half)
        case .Left:
            return translate(.none, .half)
        case .Right:
            return translate(.full, .half)
        case .TopRight:
            return translate(.full, .none)
        case .Bottom:
            return translate(.half, .full)
        case .BottomLeft:
            return translate(.none, .full)
        case .BottomRight:
            return translate(.full, .full)
        case .Top:
            return translate(.half, .none)
        case .TopLeft:
            return CGAffineTransformIdentity
        }
    }
}
