//: [Previous](@previous)

import UIKit
import ImageCoordinateSpace
//: Right
let image = UIImage(named: "rose.jpg")!
let imageView = UIImageView(image: image)
let square = CGSize(width: 200, height: 200)
imageView.bounds = CGRect(origin: CGPointZero, size: square)
imageView.backgroundColor = UIColor.greenColor()
imageView.contentMode = .Right
let imageSpace = imageView.imageCoordinateSpace()
let topLeft = imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)
image.size
//: margin should be on the left only
assert(topLeft.x == square.width - image.size.width)

let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convertPoint(bottomRight, toCoordinateSpace: imageView)
//: top margin should equal bottom margin
assert(square.height - lowerRight.y == topLeft.y)

//: image should not be stretched
assert(lowerRight.x - topLeft.x == image.size.width)
assert(lowerRight.y - topLeft.y == image.size.height)

//: [Next](@next)
