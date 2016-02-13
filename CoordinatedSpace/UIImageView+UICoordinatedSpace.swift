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
    public var bounds: CGRect

    init(view v: UIImageView) {
        imageView = v
        bounds = v.bounds
        super.init()
    }

    public func convertPoint(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        let imageSize = imageView.image!.size;
        let viewSize  = imageView.bounds.size;
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        var viewPoint = point
        let mode = imageView.contentMode
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
            viewPoint.x *= ratioX
            viewPoint.y *= ratioY
        default:
            assertionFailure("content mode \(mode) is not implemented yet")
        }
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