//
//  UIImageView+UICoordinateSpace.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit

// MARK: Adds UIImageView method to get image UICoordinateSpace
public extension UIImageView {
    /**
     Image coordinate space that accounts for view content mode
     
     Allows converting coordinates to and from image
     
     To convert a point from a view’s current coordinate space to the image coordinate space:
     ```
     let imageSpace = imageView.imageCoordinateSpace()
     let imagePoint = imageSpace.convertPoint(viewPoint, fromCoordinateSpace: imageView)
     ```

     To convert a point from a image current coordinate space to the view coordinate space:
     ```
     let viewPoint = imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)
     ```

     Similar conversions are available for CGRect:
     ```
     let viewRect = imageSpace.convertRect(imageRect, toCoordinateSpace: imageView)
     ```
     and
     ```
     let imageRect = imageSpace.convertRect(viewRect, fromCoordinateSpace: imageView)
     ```

     - Returns: image UICoordinateSpace
     - Note: when content mode is .Redraw image coordinate space assumes whole image is fully drawn in view bounds
     and behaves as for content mode .ScaleToFill
     */
    func imageCoordinateSpace() -> UICoordinateSpace {
        return ImageViewSpace(self)
    }
}
