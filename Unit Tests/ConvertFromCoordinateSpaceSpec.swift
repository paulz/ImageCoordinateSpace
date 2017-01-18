import Quick
import Nimble
import ImageCoordinateSpace

class ReverseConversionSpec: QuickSpec {
    override func spec() {
        describe("convert fromCoordinateSpace") {
            let testBundle = NSBundle(forClass: type(of: self))
            let image = UIImage(named: "rose", inBundle: testBundle, compatibleWithTraitCollection: nil)!
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

            let allModes = UIViewContentMode.ScaleToFill.rawValue.stride(
                to: UIViewContentMode.BottomRight.rawValue,
                by: 1
            )

            context("point") {
                it("should revert to original point") {
                    imageView.contentMode = .ScaleAspectFit
                    let imageSpace = imageView.contentSpace()
                    let viewPoint = imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)
                    expect(viewPoint) != imagePoint
                    let point = imageSpace.convertPoint(viewPoint, fromCoordinateSpace: imageView)
                    expect(point) == imagePoint
                }

                context("all modes") {
                    it("should also revert") {
                        for mode in allModes {
                            imageView.contentMode = UIViewContentMode(rawValue: mode)!
                            let imageSpace = imageView.contentSpace()
                            let viewPoint = imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)
                            let point = imageSpace.convertPoint(viewPoint, fromCoordinateSpace: imageView)
                            expect(point) == imagePoint
                        }
                    }
                }
            }

            context("any rect") {
                var randomRect : CGRect!

                func smallRandom() -> Int {
                    return random() % 1000
                }

                beforeEach {
                    randomRect = CGRect(
                        origin: CGPoint(x: smallRandom(), y: smallRandom()),
                        size: CGSize(width: smallRandom(), height: smallRandom())
                    )
                }

                for mode in allModes {
                    it("in mode \(mode) should reverse to original") {
                        imageView.contentMode = UIViewContentMode(rawValue: mode)!
                        let imageSpace = imageView.contentSpace()
                        let viewRect = imageSpace.convertRect(randomRect, toCoordinateSpace: imageView)
                        let imageRect = imageSpace.convertRect(viewRect, fromCoordinateSpace: imageView)
                        expect(imageRect).to(beVeryCloseTo(randomRect))
                    }
                }
            }
        }
    }
}
