//: [Previous](@previous)

import UIKit
import ImageCoordinateSpace
//: Center
let image = #imageLiteral(resourceName: "rose.jpg")
let imageView = UIImageView(image: image)
let square = CGSize(width: 200, height: 200)
imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
imageView.backgroundColor = UIColor.green
imageView.contentMode = .center
let imageSpace = imageView.contentSpace()
let topLeft = imageSpace.convert(CGPoint.zero, to: imageView)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convert(bottomRight, to: imageView)


//: image should not be stretched
assert(lowerRight.x - topLeft.x == image.size.width)
assert(lowerRight.y - topLeft.y == image.size.height)
imageView
//: [Next](@next)
