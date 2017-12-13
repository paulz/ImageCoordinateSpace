/*: 

# Image Overlay Demo

- Example: given image coordinates position another view over the image
- Experiment: change image view content mode and update overlay

*/

import UIKit
import ImageCoordinateSpace
//: Using ImageCoordinateSpace we can position overlay relative to the image
let backgroundImage = #imageLiteral(resourceName: "inspiration.jpg")
let containerView = UIImageView(image: backgroundImage)
let containerSize = CGSize(width: 200, height: 200)
containerView.bounds = CGRect(origin: CGPoint.zero, size: containerSize)
var imageSpace = containerView.contentSpace()
let svgUrl = Bundle.main.url(forResource:"overlayed", withExtension: "svg")!
let svgString = try! String(contentsOf: svgUrl)
assert(svgString.contains("x=\"321\" y=\"102\" width=\"63\" height=\"64\""))
let placement = CGRect(x: 321, y: 102, width: 63, height: 64)
let overlayView = UIImageView(image: #imageLiteral(resourceName: "hello.png"))
containerView.addSubview(overlayView)
overlayView.alpha = 0.8
func updateContentMode(_ mode: UIViewContentMode) -> UIView {
    containerView.contentMode = mode
    overlayView.frame = containerView.contentSpace().convert(placement, to: containerView)
    return containerView
}
updateContentMode(containerView.contentMode)
updateContentMode(.redraw)

//: notice redraw here is using default mode - scale to fill
overlayView.frame
assert(imageSpace.convert(overlayView.frame.origin, from: containerView) == placement.origin, "converting overlay frame origin from view should be equal to placement origin")
assert(imageSpace.convert(overlayView.frame, from: containerView) == placement, "converting overlay frame from view coordinates should equal to placement")
updateContentMode(.scaleToFill)
updateContentMode(.scaleAspectFit)
updateContentMode(.scaleAspectFill)
updateContentMode(.top)
updateContentMode(.bottom)
containerView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 400, height: 200))
updateContentMode(.left)
updateContentMode(.right)
updateContentMode(.topLeft)
updateContentMode(.topRight)
updateContentMode(.bottomLeft)
updateContentMode(.bottomRight)
//: notice redraw does not update the image but rather use previous draw mode
updateContentMode(.redraw)
//: [Next](@next)
