//
//  UIImageView+UICoordinatedSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit

public class ImageViewSpace : NSObject, UICoordinateSpace {
    var imageView : UIImageView

    init(view v: UIImageView) {
        imageView = v
        super.init()
    }

    public var bounds: CGRect {
        return CGRect(origin: CGPointZero, size: imageView.image!.size)
    }

    public func convertPoint(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        let imageSize = imageView.image!.size
        let viewSize  = imageView.bounds.size
        let widthRatio = viewSize.width / imageSize.width
        let heightRatio = viewSize.height / imageSize.height
        let mode = imageView.contentMode
        let transform : CGAffineTransform!

        func widthDiff() -> CGFloat {
            return viewSize.width - imageSize.width
        }
        func heightDiff() -> CGFloat {
            return viewSize.height - imageSize.height
        }
        enum Factor : CGFloat {
            case none = 0
            case half = 0.5
            case full = 1
        }

        func translate(xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return CGAffineTransformMakeTranslation(widthDiff() * xFactor.rawValue, heightDiff() * yFactor.rawValue)
        }

        switch mode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let scale = mode == .ScaleAspectFill ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            transform = CGAffineTransformScale(CGAffineTransformMakeTranslation (
                (viewSize.width  - imageSize.width  * scale) / 2,
                (viewSize.height  - imageSize.height  * scale) / 2
                ), scale, scale)
            break
        case .ScaleToFill, .Redraw:
            transform = CGAffineTransformMakeScale(widthRatio, heightRatio)
        case .Center:
            transform = translate(.half, .half)
        case .TopLeft:
            transform = CGAffineTransformIdentity
        case .Left:
            transform = translate(.none, .half)
        case .Right:
            transform = translate(.full, .half)
        case .TopRight:
            transform = translate(.full, .none)
        case .BottomLeft:
            transform = translate(.none, .full)
        case .BottomRight:
            transform = translate(.full, .full)
        case .Bottom:
            transform = translate(.half, .full)
        case .Top:
            transform = translate(.half, .none)
        }
        let viewPoint = CGPointApplyAffineTransform(point, transform)
        return imageView.convertPoint(viewPoint, toCoordinateSpace: coordinateSpace)
    }

    public func convertPoint(point: CGPoint, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return CGPointZero
    }

    public func convertRect(rect: CGRect, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return CGRectZero
    }

    public func convertRect(rect: CGRect, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return CGRectZero
    }

}

public extension UIImageView {
    func imageCoordinatedSpace() -> UICoordinateSpace {
        return ImageViewSpace(view: self)
    }
}