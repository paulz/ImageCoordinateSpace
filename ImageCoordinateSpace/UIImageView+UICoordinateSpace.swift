//
//  UIImageView+UICoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit

public extension UIImageView {
    func imageCoordinateSpace() -> UICoordinateSpace {
        return ImageViewSpace(view: self)
    }
}

public class ImageViewSpace : NSObject, UICoordinateSpace {
    var imageView : UIImageView

    init(view: UIImageView) {
        imageView = view
        super.init()
    }

    public var bounds: CGRect {
        return imageView.image == nil ? imageView.bounds : CGRect(origin: CGPointZero, size: imageView.image!.size)
    }

    public func convertPoint(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return imageView.convertPoint(imageToViewPoint(point), toCoordinateSpace: coordinateSpace)
    }

    public func convertPoint(point: CGPoint, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return viewToImagePoint(imageView.convertPoint(point, fromCoordinateSpace: coordinateSpace))
    }

    public func convertRect(imageRect: CGRect, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return imageView.convertRect(convertRect(imageRect, using: imageToViewPoint), toCoordinateSpace: coordinateSpace)
    }

    public func convertRect(rect: CGRect, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return convertRect(imageView.convertRect(rect, fromCoordinateSpace: coordinateSpace), using: viewToImagePoint)
    }

    // MARK: private

    private func imageToViewTransform() -> CGAffineTransform {
        let viewSize  = imageView.bounds.size
        let imageSize = imageView.image == nil ? viewSize : imageView.image!.size
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

        func translateWithFactors(tx:CGFloat, _ ty:CGFloat, _ xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return CGAffineTransformMakeTranslation(tx * xFactor.rawValue, ty * yFactor.rawValue)
        }

        func halfTranslate(tx:CGFloat, _ ty:CGFloat) -> CGAffineTransform {
            return translateWithFactors(tx, ty, .half, .half)
        }

        func translate(xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return translateWithFactors(widthDiff(), heightDiff(), xFactor, yFactor)
        }

        switch mode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let scale = mode == .ScaleAspectFill ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            transform = CGAffineTransformScale(halfTranslate(
                viewSize.width  - imageSize.width  * scale,
                viewSize.height  - imageSize.height  * scale
                ), scale, scale)
            break
        case .ScaleToFill, .Redraw:
            transform = CGAffineTransformMakeScale(widthRatio, heightRatio)
        case .Center:
            transform = translate(.half, .half)
        case .Left:
            transform = translate(.none, .half)
        case .Right:
            transform = translate(.full, .half)
        case .TopRight:
            transform = translate(.full, .none)
        case .Bottom:
            transform = translate(.half, .full)
        case .BottomLeft:
            transform = translate(.none, .full)
        case .BottomRight:
            transform = translate(.full, .full)
        case .Top:
            transform = translate(.half, .none)
        case .TopLeft:
            transform = CGAffineTransformIdentity
        }
        return transform
    }

    private func viewToImageTransform() -> CGAffineTransform {
        return CGAffineTransformInvert(imageToViewTransform())
    }

    private func imageToViewPoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, imageToViewTransform())
    }

    private func viewToImagePoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, viewToImageTransform())
    }
    
    private func convertRect(rect:CGRect, using convertPoint:((CGPoint) -> CGPoint)) -> CGRect {
        let rectBottomRight = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))

        let convertedTopLeft     = convertPoint(rect.origin)
        let convertedBottomRight = convertPoint(rectBottomRight)

        let convertedRectSize = CGSizeMake(
            abs(convertedBottomRight.x - convertedTopLeft.x),
            abs(convertedBottomRight.y - convertedTopLeft.y)
        )
        return CGRect(origin: convertedTopLeft, size: convertedRectSize)
    }
}
