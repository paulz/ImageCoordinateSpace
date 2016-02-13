//: [Previous](@previous)

//: Coordinated Space between views

import UIKit
let screen = UIScreen.mainScreen()


let inner = UIView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
inner.backgroundColor = UIColor.redColor()
inner.frame == inner.convertRect(inner.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

let outer = UIView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
outer.frame == outer.convertRect(outer.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)
outer.backgroundColor = UIColor.greenColor()

inner.convertRect(inner.bounds, toCoordinateSpace: outer)

outer.addSubview(inner)

inner.convertPoint(CGPointZero, toCoordinateSpace: outer)
inner.bounds

inner.frame == inner.convertRect(inner.bounds, toCoordinateSpace: outer)

inner.convertRect(inner.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

outer.convertRect(outer.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

//: [Next](@next)
