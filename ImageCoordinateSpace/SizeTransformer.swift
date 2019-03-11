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

    private func translateAlong(path: KeyPath<CGSize, CGFloat>, by factor: CGFloat, sizeScale scale: CGFloat) -> CGFloat {
        return factor * (boundsSize[keyPath: path] - contentSize[keyPath: path] * scale)
    }

    func translateAndScale(by factor: SizeFactor = SizeFactor(height: .center, width: .center),
                           sizeScale scale: CGFloat = 1.0) -> CGAffineTransform {
        var translation = CGSize()
        [\CGSize.width: factor.width,
         \CGSize.height: factor.height
            ].forEach {
                let (path, factor) = $0
                translation[keyPath:path] = translateAlong(path: path, by: factor, sizeScale: scale)
        }
        return CGAffineTransform(translation: translation)
    }

    func centerAndScale(using reduce: ((CGFloat, CGFloat)) -> CGFloat) -> CGAffineTransform {
        let scale = reduce(scaleToFill().scale)
        return translateAndScale(sizeScale: scale).scaledBy(scale)
    }
}
