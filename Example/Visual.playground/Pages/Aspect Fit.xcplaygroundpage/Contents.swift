//: [Previous](@previous)
import UIKit
import ImageCoordinateSpace

//: Aspect Fit
let image = #imageLiteral(resourceName: "rose.jpg")
let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
imageView.backgroundColor = UIColor.green
imageView.contentMode = .scaleAspectFit
let imageSpace = imageView.contentSpace()
let topLeft = imageSpace.convert(CGPoint.zero, to: imageView)
image.size
let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
let lowerRight = imageSpace.convert(bottomRight, to: imageView)
let bottomMargin = imageView.bounds.height - lowerRight.y
let topMargin  = topLeft.y
assert(topMargin == bottomMargin, "margins should be the same")
imageView
//: [Next](@next)
