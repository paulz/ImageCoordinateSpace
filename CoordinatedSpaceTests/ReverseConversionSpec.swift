import Quick
import Nimble

class ReverseConversionSpec: QuickSpec {
    override func spec() {
        describe("reverse conversion") {
            let image = UIImage(named: "rose")!
            let imageView = UIImageView(image: image)

            var imageSize : CGSize!
            var viewSize  : CGSize!
            var widthRatio : CGFloat!
            var heightRatio : CGFloat!
            let imagePoint = CGPointZero
            var viewPoint : CGPoint!

            beforeEach {
                let square = CGSize(width: 100, height: 100)
                imageView.bounds = CGRect(origin: CGPointZero, size: square)
                imageSize = image.size
                viewSize  = imageView.bounds.size
                widthRatio = viewSize.width / imageSize.width
                heightRatio = viewSize.height / imageSize.height

                viewPoint = imagePoint
            }

            func expectViewPointMatchImagePoint(file: String = __FILE__, line: UInt = __LINE__) {
                expect(imageView.imageCoordinatedSpace().convertPoint(imagePoint, toCoordinateSpace: imageView), file:file, line: line) == viewPoint
            }

            fcontext("point") {
                it("should revert to original point") {
                    imageView.contentMode = .ScaleAspectFit
                    let viewPoint = imageView.imageCoordinatedSpace().convertPoint(imagePoint, toCoordinateSpace: imageView)
                    print(viewPoint)
                    expect(viewPoint) != imagePoint
                    let point = imageView.imageCoordinatedSpace().convertPoint(viewPoint, fromCoordinateSpace: imageView)
                    expect(point) == imagePoint
                }

                context("all modes") {
                    it("should also revert") {
                        for var mode = UIViewContentMode.ScaleToFill.rawValue; mode <= UIViewContentMode.BottomRight.rawValue; mode++ {
                            imageView.contentMode = UIViewContentMode(rawValue: mode)!
                            let viewPoint = imageView.imageCoordinatedSpace().convertPoint(imagePoint, toCoordinateSpace: imageView)
                            let point = imageView.imageCoordinatedSpace().convertPoint(viewPoint, fromCoordinateSpace: imageView)
                            expect(point) == imagePoint
                        }
                    }
                }
            }
        }
    }
}
