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

func halfTranslate(tx tx:CGFloat, ty:CGFloat) -> CGAffineTransform {
    return translateWithFactors(tx:tx, ty:ty, xFactor:.half, yFactor:.half)
}


class ImageCoordinateSpace : NSObject, UICoordinateSpace {
    var imageView : UICoordinateSpace
    var imageSize : CGSize?
    var contentMode : UIViewContentMode

    init(_ view: UIImageView) {
        imageView = view
        imageSize = view.image?.size
        contentMode = view.contentMode
        super.init()
    }

    var bounds: CGRect {
        return imageSize == nil ? imageView.bounds : CGRect(origin: CGPointZero, size: imageSize!)
    }

    func convertPoint(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return imageView.convertPoint(CGPointApplyAffineTransform(point, imageToViewTransform), toCoordinateSpace: coordinateSpace)
    }

    func convertRect(rect: CGRect, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return imageView.convertRect(CGRectApplyAffineTransform(rect, imageToViewTransform), toCoordinateSpace: coordinateSpace)
    }

    func convertPoint(point: CGPoint, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return CGPointApplyAffineTransform(imageView.convertPoint(point, fromCoordinateSpace: coordinateSpace), viewToImageTransform)
    }

    func convertRect(rect: CGRect, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGRect {
        return CGRectApplyAffineTransform(imageView.convertRect(rect, fromCoordinateSpace: coordinateSpace), viewToImageTransform)
    }

    // MARK: private

    private lazy var imageToViewTransform : CGAffineTransform = {
        let viewSize  = self.imageView.bounds.size
        let imageSize = self.imageSize == nil ? viewSize : self.imageSize!

        func translate(xFactor:Factor, _ yFactor:Factor) -> CGAffineTransform {
            return translateWithFactors(
                tx: viewSize.width - imageSize.width,
                ty: viewSize.height - imageSize.height,
                xFactor: xFactor,
                yFactor: yFactor
            )
        }

        let widthRatio = viewSize.width / imageSize.width
        let heightRatio = viewSize.height / imageSize.height

        switch self.contentMode {
        case .ScaleAspectFit, .ScaleAspectFill:
            let scale = self.contentMode == .ScaleAspectFill ? max(widthRatio, heightRatio) : min(widthRatio, heightRatio)
            return CGAffineTransformScale(halfTranslate(
                tx: viewSize.width  - imageSize.width  * scale,
                ty: viewSize.height  - imageSize.height  * scale
                ), scale, scale)
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
    }()

    private lazy var viewToImageTransform : CGAffineTransform = {
        return CGAffineTransformInvert(self.imageToViewTransform)
    }()
}

