//
//  ViewContentModeTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import UIKit

struct ViewContentModeTransformer {
    let contentMode: UIView.ContentMode
    let sizeTransformer: SizeTransformer

    init(bounds: CGSize, content: CGSize, mode: UIView.ContentMode) {
        sizeTransformer = SizeTransformer(boundsSize: bounds, contentSize: content)
        contentMode = mode
    }

    func contentToViewTransform() -> CGAffineTransform {
        switch contentMode {
        case .scaleAspectFill:
            return sizeTransformer.translateAndScale(using: max)
        case .scaleAspectFit:
            return sizeTransformer.translateAndScale(using: min)
        case .scaleToFill, .redraw:
            return sizeTransformer.scaleToFill()
        case .topLeft:
            return .identity
        default:
            return sizeTransformer.translate(factor: SizeFactor(contentMode))
        }
    }
}
