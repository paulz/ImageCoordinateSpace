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
        case .scaleAspectFit, .scaleAspectFill:
            let expand = contentMode == .scaleAspectFill
            let scale = expand ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            return translateWithFactors(
                    tx: viewSize.width - width * scale,
                    ty: viewSize.height - height * scale,
                    xFactor: .half,
                    yFactor: .half
                ).scaledBy(x: scale,
                y: scale)
        case .scaleToFill, .redraw:
            return CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        case .center:
            return translate(.half, .half)
        case .left:
            return translate(.none, .half)
        case .right:
            return translate(.full, .half)
        case .topRight:
            return translate(.full, .none)
        case .bottom:
            return translate(.half, .full)
        case .bottomLeft:
            return translate(.none, .full)
        case .bottomRight:
            return translate(.full, .full)
        case .top:
            return translate(.half, .none)
        case .topLeft:
            return CGAffineTransform.identity
        }
    }
}
