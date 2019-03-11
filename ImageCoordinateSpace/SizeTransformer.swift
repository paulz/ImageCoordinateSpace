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

    private func translateAxies(by: ScaleFactor, sizeScale scale: CGFloat, path: KeyPath<CGSize, CGFloat>) -> CGFloat {
        return by.scale(value: boundsSize[keyPath: path] - contentSize[keyPath: path] * scale)
    }

    func translate(factor: SizeFactor, sizeScale scale: CGFloat = 1.0) -> CGAffineTransform {
        var result = CGSize()
        [\CGSize.width: factor.width,
         \CGSize.height: factor.height
            ].forEach {
                let (path, factor) = $0
                result[keyPath:path] = translateAxies(by: factor, sizeScale: scale, path: path)
        }
        return CGAffineTransform(translationX: result.width, y: result.height)
    }

    func translateAndScale(using reduceFunction: (CGFloat, CGFloat) -> CGFloat) -> CGAffineTransform {
        let scale: CGFloat = {
            let fill = scaleToFill()
            return reduceFunction(fill.scaleX, fill.scaleY)
        }()
        return translate(factor: SizeFactor(), sizeScale: scale).scaledBy(x: scale, y: scale)
    }
}
