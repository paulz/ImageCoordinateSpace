//
//  ImageCoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

import UIKit

enum Factor : CGFloat {
    case none = 0
    case half = 0.5
    case full = 1
}

func translateWithFactors(tx tx:CGFloat, ty:CGFloat, xFactor:Factor, yFactor:Factor) -> CGAffineTransform {
    return CGAffineTransformMakeTranslation(tx * xFactor.rawValue, ty * yFactor.rawValue)
}

class ImageCoordinateSpace {
    var viewSpace : UICoordinateSpace
    var imageSize : CGSize?
    var contentMode : UIViewContentMode

    init(_ view: UIImageView) {
        viewSpace = view
        imageSize = view.image?.size
        contentMode = view.contentMode
    }

    func transformedSpace() -> UICoordinateSpace {
        return TransformedCoordinateSpace(
            size: imageSize ?? viewSpace.bounds.size,
            transform: imageSize != nil ? imageToViewTransform() : CGAffineTransformIdentity,
            destination: viewSpace)
    }

    // MARK: private

    private func imageToViewTransform() -> CGAffineTransform {
        let viewSize  = viewSpace.bounds.size
        let imageHeight = imageSize!.height
        let imageWidth = imageSize!.width

        func translate(xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return translateWithFactors(
                tx: viewSize.width - imageWidth,
                ty: viewSize.height - imageHeight,
                xFactor: xFactor,
                yFactor: yFactor
            )
        }

        let widthRatio = viewSize.width / imageWidth
        let heightRatio = viewSize.height / imageHeight

        switch contentMode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let expand = contentMode == .ScaleAspectFill
            let scale = expand ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            return CGAffineTransformScale(
                translateWithFactors(
                    tx: viewSize.width - imageWidth * scale,
                    ty: viewSize.height - imageHeight * scale,
                    xFactor: .half,
                    yFactor: .half
                ),
                scale,
                scale)
        case .ScaleToFill, .Redraw:
            return CGAffineTransformMakeScale(widthRatio, heightRatio)
        case .Center:
            return translate(.half, .half)
        case .Left:
            return translate(.none, .half)
        case .Right:
            return translate(.full, .half)
        case .TopRight:
            return translate(.full, .none)
        case .Bottom:
            return translate(.half, .full)
        case .BottomLeft:
            return translate(.none, .full)
        case .BottomRight:
            return translate(.full, .full)
        case .Top:
            return translate(.half, .none)
        case .TopLeft:
            return CGAffineTransformIdentity
        }
    }
}

