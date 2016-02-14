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

            context("point") {
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

            context("any rect") {
                var randomRect : CGRect!

                func smallRandom() -> Int {
                    return random() % 100
                }

                beforeEach {
                    randomRect = CGRect(origin: CGPoint(x: smallRandom(), y: smallRandom()), size: CGSize(width: smallRandom(), height: smallRandom()))
                }

                func beVeryCloseTo(expectedValue: CGRect!) -> MatcherFunc <CGRect> {
                    return MatcherFunc { actualExpression, failureMessage in
                        failureMessage.postfixMessage = "equal <\(expectedValue)>"
                        let actual = try actualExpression.evaluate()!
                        let delta : CGFloat = 0.0000000000001
                        return actual.origin.x - expectedValue.origin.x < delta &&
                            actual.origin.y - expectedValue.origin.y < delta &&
                            actual.size.width - expectedValue.size.width < delta &&
                            actual.size.height - expectedValue.size.height < delta
                    }
                }

                for var mode = UIViewContentMode.ScaleToFill.rawValue; mode <= UIViewContentMode.BottomRight.rawValue; mode++ {
                    it("in mode \(mode) should reverse to original") {
                        imageView.contentMode = UIViewContentMode(rawValue: mode)!
                        let viewRect = imageView.imageCoordinatedSpace().convertRect(randomRect, toCoordinateSpace: imageView)
                        let imageRect = imageView.imageCoordinatedSpace().convertRect(viewRect, fromCoordinateSpace: imageView)
                        expect(imageRect).to(beVeryCloseTo(randomRect))
                    }
                }
            }
        }
    }
}
