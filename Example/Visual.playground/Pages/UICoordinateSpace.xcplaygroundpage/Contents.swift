//: [Previous](@previous)

//: The UICoordinateSpace protocol defines methods for converting between different frames of reference on a screen.

import UIKit
let screen = UIScreen.mainScreen()

let inner = UIView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
inner.backgroundColor = UIColor.redColor()

//: Unplaced view frame equal bounds on screen
inner.frame == inner.convertRect(inner.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

let outer = UIView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
//: Unplaced view frame equal bounds on screen
outer.frame == outer.convertRect(outer.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)
outer.backgroundColor = UIColor.greenColor()

//: Inner view bounds in space of outer view is frame on screen
inner.convertRect(inner.bounds, toCoordinateSpace: outer)

outer.addSubview(inner)

inner.convertPoint(CGPointZero, toCoordinateSpace: outer)
inner.bounds

//: Inner view bounds in space of outer view equal frame
inner.frame == inner.convertRect(inner.bounds, toCoordinateSpace: outer)

//: Outer view frame is in coordinates of screen
outer.convertRect(outer.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

//: Inner view on screen makes sense
inner.convertRect(inner.bounds, toCoordinateSpace: screen.fixedCoordinateSpace)

//: [Next](@next)
