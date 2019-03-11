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

    private func translateAxies(by factor: CGFloat, sizeScale scale: CGFloat, path: KeyPath<CGSize, CGFloat>) -> CGFloat {
        return factor * (boundsSize[keyPath: path] - contentSize[keyPath: path] * scale)
    }

    func translate(factor: SizeFactor, sizeScale scale: CGFloat = 1.0) -> CGAffineTransform {
        var translation = CGSize()
        [\CGSize.width: factor.width,
         \CGSize.height: factor.height
            ].forEach {
                let (path, factor) = $0
                translation[keyPath:path] = translateAxies(by: factor, sizeScale: scale, path: path)
        }
        return CGAffineTransform(translation: translation)
    }

    func translateAndScale(using reduce: ((CGFloat, CGFloat)) -> CGFloat) -> CGAffineTransform {
        let scale = reduce(scaleToFill().scale)
        return translate(factor: SizeFactor(height: .center, width: .center), sizeScale: scale).scaledBy(scale)
    }
}
