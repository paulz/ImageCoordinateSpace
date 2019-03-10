//: [Previous](@previous)

import UIKit
import ImageCoordinateSpace
//: Aspect Fill
let image = UIImage(named: "rose.jpg")!
let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
imageView.backgroundColor = UIColor.green
imageView.contentMode = .scaleAspectFill
let imageSpace = imageView.contentSpace()
let topLeft = imageSpace.convert(CGPoint.zero, to: imageView)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convert(bottomRight, to: imageView)
let bottomMargin = imageView.bounds.width - lowerRight.x
let topMargin  = topLeft.x
assert(topMargin == bottomMargin, "negative margins should be the same")
imageView

//: [Next](@next)
