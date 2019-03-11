//
//  CGAffineTransform+Scale.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/11/18.
//

extension CGAffineTransform {
    func scale(using reduce: (CGFloat, CGFloat) -> CGFloat) -> CGFloat {
        return reduce(a, d)
    }

    init(scaleTo size: CGSize, from: CGSize) {
        self.init(scaleX: size.width / from.width,
                  y: size.height / from.height)
    }

    init(translation size: CGSize) {
        self.init(translationX: size.width, y: size.height)
    }

    func scaledBy(_ scale: CGFloat) -> CGAffineTransform {
        return scaledBy(x: scale, y: scale)
    }
}
