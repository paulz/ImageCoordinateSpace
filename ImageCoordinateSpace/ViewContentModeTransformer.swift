//
//  ViewContentModeTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

struct ViewContentModeTransformer {
    let boundsSize : CGSize
    let contentSize : CGSize
    let contentMode : UIViewContentMode
    
    private func scaleToFill() -> CGAffineTransform {
        return CGAffineTransform(scaleTo: boundsSize, from: contentSize)
    }

    private func translate(_ byX:ScaleFactor, _ byY:ScaleFactor, sizeScale scale:CGFloat = 1.0) -> CGAffineTransform {
        let x = byX.scale(value: boundsSize.width - contentSize.width * scale)
        let y = byY.scale(value: boundsSize.height - contentSize.height * scale)
        return CGAffineTransform(translationX: x, y: y)
    }
    
    private func translateAndScale(using reduceFunction:(CGFloat,CGFloat)->CGFloat) -> CGAffineTransform {
        let fill = scaleToFill()
        let scale = reduceFunction(fill.scaleX, fill.scaleY)
        return translate(.half, .half, sizeScale: scale).scaledBy(x: scale, y: scale)
    }
    
    func contentToViewTransform() -> CGAffineTransform {
        switch contentMode {
        case .scaleAspectFill:
            return translateAndScale(using: max)
        case .scaleAspectFit:
            return translateAndScale(using: min)
        case .scaleToFill, .redraw:
            return scaleToFill()
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
