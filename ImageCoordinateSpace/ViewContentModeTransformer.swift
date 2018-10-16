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
    let contentMode : UIView.ContentMode
    
    private func scaleToFill() -> CGAffineTransform {
        return CGAffineTransform(scaleTo: boundsSize, from: contentSize)
    }

    private func translateAxies(by:ScaleFactor, sizeScale scale:CGFloat, path: KeyPath<CGSize, CGFloat>) -> CGFloat {
        return by.scale(value: boundsSize[keyPath: path] - contentSize[keyPath: path] * scale)
    }

    private func translate(factor:SizeFactor, sizeScale scale:CGFloat = 1.0) -> CGAffineTransform {
        var result = CGSize()
        [\CGSize.width: factor.width,
         \CGSize.height: factor.height
            ].forEach {
                let (path, factor) = $0
                result[keyPath:path] = translateAxies(by: factor, sizeScale: scale, path: path)
        }
        return CGAffineTransform(translationX: result.width, y: result.height)
    }
    
    private func translateAndScale(using reduceFunction:(CGFloat,CGFloat)->CGFloat) -> CGAffineTransform {
        let scale: CGFloat = {
            let fill = scaleToFill()
            return reduceFunction(fill.scaleX, fill.scaleY)
        }()
        return translate(factor: SizeFactor(height: .half, width: .half), sizeScale: scale).scaledBy(x: scale, y: scale)
    }

    private static let placements: [UIView.ContentMode: SizeFactor] = [
        .center:      SizeFactor(),
        .left:        SizeFactor(width: .left),
        .right:       SizeFactor(width: .right),
        .top:         SizeFactor(height:.top),
        .bottom:      SizeFactor(height:.bottom),
        .topLeft:     SizeFactor(height:.top, width:.left),
        .topRight:    SizeFactor(height:.top, width:.right),
        .bottomLeft:  SizeFactor(height:.bottom, width:.left),
        .bottomRight: SizeFactor(height:.bottom, width:.right),
    ]

    private func translatePlacement() -> CGAffineTransform {
        let placement = type(of: self).placements[contentMode]!
        return translate(factor: placement)
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
        default:
            return translatePlacement()
        }
    }
}
