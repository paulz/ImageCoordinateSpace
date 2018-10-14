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

    private func translate(xFactor:ScaleFactor, yFactor:ScaleFactor, sizeScale scale:CGFloat = 1.0) -> CGAffineTransform {
        let scaled = [(xFactor, \CGSize.width),
                      (yFactor, \CGSize.height)].map {translateAxies(by: $0.0, sizeScale: scale, path: $0.1)}
        let (x,y) = (scaled[0], scaled[1])
        return CGAffineTransform(translationX: x, y: y)
    }
    
    private func translateAndScale(using reduceFunction:(CGFloat,CGFloat)->CGFloat) -> CGAffineTransform {
        let scale: CGFloat = {
            let fill = scaleToFill()
            return reduceFunction(fill.scaleX, fill.scaleY)
        }()
        return translate(xFactor: .half, yFactor: .half, sizeScale: scale).scaledBy(x: scale, y: scale)
    }

    static let placements: [UIView.ContentMode: (y:ScaleFactor?, x:ScaleFactor?)] = [
        .center: (nil, nil),
        .left: (nil, .left),
        .right: (nil, .right),
        .top: (.top, nil),
        .bottom: (.bottom, nil),
        .topLeft: (.top, .left),
        .topRight: (.top, .right),
        .bottomLeft: (.bottom, .left),
        .bottomRight: (.bottom, .right),
        ]

    func translatePlacement() -> CGAffineTransform {
        let placement = type(of: self).placements[contentMode]!
        return translate(xFactor: placement.x ?? .center, yFactor: placement.y ?? .center)
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
