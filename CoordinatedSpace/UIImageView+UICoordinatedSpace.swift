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
        var transform : CGAffineTransform! = CGAffineTransformIdentity
        switch mode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let scale : CGFloat
            scale = mode == .ScaleAspectFill ? max(ratioX, ratioY) : min(ratioX, ratioY)
            viewPoint.x *= scale
            viewPoint.y *= scale

            viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2
            viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2
            break
        case .ScaleToFill, .Redraw:
            transform = CGAffineTransformMakeScale(ratioX, ratioY)
        case .Center:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width / 2  - imageSize.width  / 2,
                viewSize.height / 2 - imageSize.height / 2
            )
        case .TopLeft:
            transform = CGAffineTransformIdentity
        case .Left:
            transform = CGAffineTransformMakeTranslation(
                0,
                viewSize.height / 2 - imageSize.height / 2
            )
        case .Right:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width - imageSize.width,
                viewSize.height / 2 - imageSize.height / 2
            )
        case .TopRight:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width - imageSize.width,
                0
            )
        case .BottomLeft:
            transform = CGAffineTransformMakeTranslation(
                0,
                viewSize.height - imageSize.height
            )
        case .BottomRight:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width - imageSize.width,
                viewSize.height - imageSize.height
            )
        case .Bottom:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width / 2  - imageSize.width  / 2,
                viewSize.height - imageSize.height
            )
        case .Top:
            transform = CGAffineTransformMakeTranslation(
                viewSize.width / 2  - imageSize.width  / 2,
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