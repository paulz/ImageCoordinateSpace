import Quick
import Nimble
@testable import ImageCoordinateSpace

extension UICoordinateSpace {
    public func applying(_ t: CGAffineTransform) -> UICoordinateSpace {
        return TransformedCoordinateSpace(original: self, transform: t, bounds: bounds)
    }
}

class ReverseConversionSpec: QuickSpec {
    override func spec() {
        describe("convert fromCoordinateSpace") {
            let testBundle = Bundle(for: type(of: self))
            let image = UIImage(named: "rose", in: testBundle, compatibleWith: nil)!
            let imageView = UIImageView(image: image)

            let imagePoint = CGPoint.zero

            beforeEach {
                let square = CGSize(width: 100, height: 100)
                imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
            }

            let allModes = stride(from:UIViewContentMode.scaleToFill.rawValue,
                                  to: UIViewContentMode.bottomRight.rawValue,
                                  by: 1
            )

            context("point") {
                it("should revert to original point") {
                    imageView.contentMode = .scaleAspectFit
                    let imageSpace = imageView.contentSpace()
                    let viewPoint = imageSpace.convert(imagePoint, to: imageView)
                    expect(viewPoint) != imagePoint
                    let point = imageSpace.convert(viewPoint, from: imageView)
                    expect(point) == imagePoint
                }

                context("all modes") {
                    it("should also revert") {
                        for mode in allModes {
                            imageView.contentMode = UIViewContentMode(rawValue: mode)!
                            let imageSpace = imageView.contentSpace()
                            let viewPoint = imageSpace.convert(imagePoint, to: imageView)
                            let point = imageSpace.convert(viewPoint, from: imageView)
                            expect(point) == imagePoint
                        }
                    }
                }
            }

            context("any rect") {
                var randomRect : CGRect!

                beforeEach {
                    randomRect = nextRandomRect()
                }

                for mode in allModes {
                    it("in mode \(mode) should reverse to original") {
                        imageView.contentMode = UIViewContentMode(rawValue: mode)!
                        let imageSpace = imageView.contentSpace()
                        let viewRect = imageSpace.convert(randomRect, to: imageView)
                        let imageRect = imageSpace.convert(viewRect, from: imageView)
                        expect(imageRect) ≈ randomRect ± 0.000001
                    }
                }
            }
        }
    }
}
