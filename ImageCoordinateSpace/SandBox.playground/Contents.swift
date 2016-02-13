//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let image = UIImage(named: "rose.jpg")!
print(image)


let imageView = UIImageView(image: image)
let square = CGSize(width: 100, height: 100)
imageView.bounds = CGRect(origin: CGPointZero, size: square)
imageView.contentMode = .ScaleAspectFit
imageView.imageCoordinatedSpace()