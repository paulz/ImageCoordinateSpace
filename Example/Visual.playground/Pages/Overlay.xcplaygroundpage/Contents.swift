/*: 

# Image Overlay Demo

- Example: given image coordinates position another view over the image
- Experiment: change image view content mode and update overlay

*/

import UIKit
import ImageCoordinateSpace
//: Using ImageCoordinateSpace we can position overlay relative to the image
let backgroundImage = [#Image(imageLiteral: "inspiration.jpg")#]
let containerView = UIImageView(image: backgroundImage)
let containerSize = CGSize(width: 200, height: 200)
containerView.bounds = CGRect(origin: CGPointZero, size: containerSize)
var imageSpace = containerView.contentSpace()
let svgUrl = NSBundle.mainBundle().URLForResource("overlayed", withExtension: "svg")!
let svgString = try! String(contentsOfURL: svgUrl)
assert(svgString.containsString("x=\"321\" y=\"102\" width=\"63\" height=\"64\""))
let placement = CGRect(x: 321, y: 102, width: 63, height: 64)
let overlayView = UIImageView(image:[#Image(imageLiteral: "hello.png")#])
containerView.addSubview(overlayView)
overlayView.alpha = 0.8
func updateContentMode(mode: UIViewContentMode) -> UIView {
    containerView.contentMode = mode
    overlayView.frame = containerView.contentSpace().convertRect(placement, toCoordinateSpace: containerView)
    return containerView
}
updateContentMode(containerView.contentMode)
updateContentMode(.Redraw) // notice redraw here is using default mode - scale to fill
overlayView.frame
assert(imageSpace.convertPoint(overlayView.frame.origin, fromCoordinateSpace: containerView) == placement.origin, "converting overlay frame origin from view should be equal to placement origin")
assert(imageSpace.convertRect(overlayView.frame, fromCoordinateSpace: containerView) == placement, "converting overlay frame from view coordinates should equal to placement")
updateContentMode(.ScaleToFill)
updateContentMode(.ScaleAspectFit)
updateContentMode(.ScaleAspectFill)
updateContentMode(.Top)
updateContentMode(.Bottom)
containerView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 400, height: 200))
updateContentMode(.Left)
updateContentMode(.Right)
updateContentMode(.TopLeft)
updateContentMode(.TopRight)
updateContentMode(.BottomLeft)
updateContentMode(.BottomRight)
// notice redraw does not update the image but rather use previous draw mode
updateContentMode(.Redraw)
//: [Next](@next)
