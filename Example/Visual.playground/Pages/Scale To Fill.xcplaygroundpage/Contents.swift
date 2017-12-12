//: [Previous](@previous)

import UIKit
import ImageCoordinateSpace
//: Scale
let image = #imageLiteral(resourceName: "rose.jpg")
let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
imageView.backgroundColor = UIColor.green
imageView.contentMode = .scaleToFill
let imageSpace = imageView.contentSpace()
let topLeft = imageSpace.convert(CGPoint.zero, to: imageView)

//: top left corners should be the same
assert(topLeft == CGPoint.zero)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convert(bottomRight, to: imageView)

//: bottom right corners should be the same
assert(lowerRight.x == square.width, "should the view width")
assert(lowerRight.y == square.height, "should the view height")

imageView
//: [Next](@next)
