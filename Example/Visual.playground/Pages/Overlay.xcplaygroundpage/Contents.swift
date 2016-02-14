//: [Previous](@previous)

import UIKit
import CoordinatedSpace
//: Center
let backgroundImage = UIImage(named: "inspiration.jpg")!
let containerView = UIImageView(image: backgroundImage)
let imageSpace = containerView.imageCoordinatedSpace()
let containerSize = CGSize(width: 200, height: 200)
containerView.contentMode = .Center
containerView.bounds = CGRect(origin: CGPointZero, size: containerSize)
// x="321" y="102" width="63" height="64"
let placement = CGRect(x: 321, y: 102, width: 63, height: 64)
let overlayView = UIImageView(image: UIImage(named: "hello.png")!)
containerView.addSubview(overlayView)
overlayView.alpha = 0.8
func updateContentMode(mode: UIViewContentMode) -> UIView {
    containerView.contentMode = mode
    overlayView.frame = imageSpace.convertRect(placement, toCoordinateSpace: containerView)
    return containerView
}
updateContentMode(containerView.contentMode)
overlayView.frame
imageSpace.convertPoint(overlayView.frame.origin, fromCoordinateSpace: containerView)
imageSpace.convertRect(overlayView.frame, fromCoordinateSpace: containerView)
updateContentMode(.ScaleToFill)
updateContentMode(.ScaleAspectFit)
updateContentMode(.ScaleAspectFill)
updateContentMode(.Top)
updateContentMode(.Bottom)
containerView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 400, height: 200))
updateContentMode(.Left)
updateContentMode(.Right)
updateContentMode(.TopLeft)
updateContentMode(.TopRight)
updateContentMode(.BottomLeft)
updateContentMode(.BottomRight)
//: [Next](@next)
