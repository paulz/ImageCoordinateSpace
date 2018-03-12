//
//  UIView+UICoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit

// MARK: Adds UIView contentCoordinateSpace property
public extension UIView {
    /**
     View coordinate space that accounts for view content mode
     
     Allows converting coordinates to and from image
     
     To convert a point from a view’s current coordinate space to the image coordinate space:
     ```
     let imageSpace = imageView.contentSpace()
     let imagePoint = imageSpace.convert(viewPoint, from: imageView)
     ```

     To convert a point from a image current coordinate space to the view coordinate space:
     ```
     let viewPoint = imageSpace.convert(imagePoint, to: imageView)
     ```

     Similar conversions are available for CGRect:
     ```
     let viewRect = imageSpace.convert(imageRect, to: imageView)
     ```
     and
     ```
     let imageRect = imageSpace.convert(viewRect, from: imageView)
     ```
     
     - Note: content coordinate space depends on view bounds, image size and view content mode, so you need to
     obtain current contentSpace() if any of those properties change

     - Returns: view content UICoordinateSpace
     - Note: when content mode is .Redraw content coordinate space assumes all view content is fully drawn in view bounds
     and behaves as for content mode .ScaleToFill
     */
    func contentSpace() -> UICoordinateSpace {
        return contentAdjustment().transformingToSpace(self)
    }

    /**
     Affine transform that to be applied to view content coordinates to convert them to view coordinates

     - Note: content to bounds transform depends on view bounds, image size and view content mode, so you need to
     obtain current contentToBoundsTransform() if any of those properties change

     - Returns: CGAffineTransform to convert from content coordinates into view coordinates
     */
    func contentToBoundsTransform() -> CGAffineTransform {
        return contentAdjustment().contentTransformToSize()
    }
}
