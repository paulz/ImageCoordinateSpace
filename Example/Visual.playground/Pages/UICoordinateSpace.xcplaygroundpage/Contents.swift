//: [Previous](@previous)

//: The UICoordinateSpace protocol defines methods for converting between different frames of reference on a screen.

import UIKit
let screen = UIScreen.main

let inner = UIView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
inner.backgroundColor = UIColor.red

//: Unplaced view frame equal bounds on screen
inner.frame == inner.convert(inner.bounds, to: screen.fixedCoordinateSpace)

let outer = UIView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
//: Unplaced view frame equal bounds on screen
outer.frame == outer.convert(outer.bounds, to: screen.fixedCoordinateSpace)
outer.backgroundColor = UIColor.green

//: Inner view bounds in space of outer view is frame on screen
inner.convert(inner.bounds, to: outer)

outer.addSubview(inner)

inner.convert(CGPoint.zero, to: outer)
inner.bounds

//: Inner view bounds in space of outer view equal frame
inner.frame == inner.convert(inner.bounds, to: outer)

//: Outer view frame is in coordinates of screen
outer.convert(outer.bounds, to: screen.fixedCoordinateSpace)

//: Inner view on screen makes sense
inner.convert(inner.bounds, to: screen.fixedCoordinateSpace)

//: [Next](@next)
