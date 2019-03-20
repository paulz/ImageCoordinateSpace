//
//  SizeTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/10/19.
//

import Foundation

struct SizeTransformer {
    let boundsSize: CGSize
    let contentSize: CGSize

    func isIdentity() -> Bool {
        return boundsSize == contentSize
    }

    func scaleToFill() -> CGAffineTransform {
        return CGAffineTransform(scaleTo: boundsSize, from: contentSize)
    }

    func translateAndScale(by factor: SizeFactor = SizeFactor(height: .center, width: .center),
                           sizeScale scale: CGFloat = 1.0) -> CGAffineTransform {
        return CGAffineTransform(translation: factor.axesPathMap { path, factorValue in
            factorValue * (boundsSize[keyPath: path] - contentSize[keyPath: path] * scale)
        })
    }

    func centerAndScale(using reduce: (CGFloat, CGFloat) -> CGFloat) -> CGAffineTransform {
        let scale = scaleToFill().scale(using: reduce)
        return translateAndScale(sizeScale: scale).scaledBy(scale)
    }
}
