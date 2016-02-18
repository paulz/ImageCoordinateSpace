//: [Previous](@previous)

import UIKit
import ImageCoordinateSpace
//: Scale
let image = UIImage(named: "rose.jpg")!
let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPointZero, size: square)
imageView.backgroundColor = UIColor.greenColor()
imageView.contentMode = .ScaleToFill
let imageSpace = imageView.contentSpace()
let topLeft = imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)
assert//: top left corners should be the same
(topLeft == CGPointZero)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convertPoint(bottomRight, toCoordinateSpace: imageView)
assert//: bottom right corners should be the same
(lowerRight.x == square.width, "should the view width")
assert(lowerRight.y == square.height, "should the view height")


//: [Next](@next)
