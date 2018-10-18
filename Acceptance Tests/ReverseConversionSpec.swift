import Quick
import Nimble
import ImageCoordinateSpace

public class ReverseConversionSpec: QuickSpec {
    override public func spec() {
        describe("convert fromCoordinateSpace") {
            let image = UIImage.testImage(CGSize(width: 145, height: 109))
            let imageView = UIImageView(image: image)

            let imagePoint = CGPoint.zero

            beforeEach {
                let square = CGSize(width: 100, height: 100)
                imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
            }

            let allContentModes = stride(from:UIView.ContentMode.scaleToFill.rawValue,
                                  to: UIView.ContentMode.bottomRight.rawValue,
                                  by: 1
            )

            context("point") {
                it("should revert to original point") {
                    imageView.contentMode = .scaleAspectFit
                    let imageSpace = imageView.contentSpace()
                    let viewPoint = imageSpace.convert(imagePoint, to: imageView)
                    expect(viewPoint) != imagePoint
                    let point = imageSpace.convert(viewPoint, from: imageView)
                    expect(point) ≈ imagePoint
                }

                context("in all content modes") {
                    it("should also revert to original point") {
                        for contentMode in allContentModes {
                            imageView.contentMode = UIView.ContentMode(rawValue: contentMode)!
                            let imageSpace = imageView.contentSpace()
                            let viewPoint = imageSpace.convert(imagePoint, to: imageView)
                            let point = imageSpace.convert(viewPoint, from: imageView)
                            expect(point) ≈ imagePoint
                        }
                    }
                }
            }

            context("any rect") {
                var randomRect : CGRect!

                beforeEach {
                    randomRect = CGRect.nextRandom()
                }

                for contentMode in allContentModes {
                    it("in content mode \(contentMode) should reverse to original") {
                        imageView.contentMode = UIView.ContentMode(rawValue: contentMode)!
                        let imageSpace = imageView.contentSpace()
                        let viewRect = imageSpace.convert(randomRect, to: imageView)
                        let imageRect = imageSpace.convert(viewRect, from: imageView)
                        expect(imageRect) ≈ randomRect ± 0.0001
                    }
                }
            }
        }
    }
}
