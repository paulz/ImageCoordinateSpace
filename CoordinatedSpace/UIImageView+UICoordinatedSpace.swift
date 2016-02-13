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
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        var viewPoint = point
        let mode = imageView.contentMode
        let transform : CGAffineTransform!

        func widthDiff() -> CGFloat {
            return viewSize.width - imageSize.width
        }
        func heightDiff() -> CGFloat {
            return viewSize.height - imageSize.height
        }

        switch mode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let scale : CGFloat
            scale = mode == .ScaleAspectFill ? max(ratioX, ratioY) : min(ratioX, ratioY)
            transform = CGAffineTransformScale(CGAffineTransformMakeTranslation (
                (viewSize.width  - imageSize.width  * scale) / 2,
                (viewSize.height  - imageSize.height  * scale) / 2
                ), scale, scale)
            break
        case .ScaleToFill, .Redraw:
            transform = CGAffineTransformMakeScale(ratioX, ratioY)
        case .Center:
            transform = CGAffineTransformMakeTranslation(
                widthDiff() / 2,
                heightDiff() / 2
            )
        case .TopLeft:
            transform = CGAffineTransformIdentity
        case .Left:
            transform = CGAffineTransformMakeTranslation(
                0,
                heightDiff() / 2
            )
        case .Right:
            transform = CGAffineTransformMakeTranslation(
                widthDiff(),
                heightDiff() / 2
            )
        case .TopRight:
            transform = CGAffineTransformMakeTranslation(
                widthDiff(),
                0
            )
        case .BottomLeft:
            transform = CGAffineTransformMakeTranslation(
                0,
                heightDiff()
            )
        case .BottomRight:
            transform = CGAffineTransformMakeTranslation(
                widthDiff(),
                heightDiff()
            )
        case .Bottom:
            transform = CGAffineTransformMakeTranslation(
                widthDiff() / 2,
                heightDiff()
            )
        case .Top:
            transform = CGAffineTransformMakeTranslation(
                widthDiff() / 2,
                0
            )
        }
        viewPoint = CGPointApplyAffineTransform(viewPoint, transform)

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