//: [Previous](@previous)

import UIKit
import CoordinatedSpace
//: Aspect Fill
let image = UIImage(named: "rose.jpg")!
let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPointZero, size: square)
imageView.backgroundColor = UIColor.greenColor()
imageView.contentMode = .ScaleAspectFill
let imageSpace = imageView.imageCoordinatedSpace()
let topLeft = imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convertPoint(bottomRight, toCoordinateSpace: imageView)
let bottomMargin = imageView.bounds.height - lowerRight.y
let topMargin  = topLeft.y
//: margins should be the same
topMargin == bottomMargin


//: [Next](@next)
