import Quick
import Nimble

class UIImageView_ImageCoordinatedSpaceSpec: QuickSpec {
    override func spec() {
        let image = UIImage(named: "rose")!
        let imageView = UIImageView(image: image)

        describe("view UICoordinateSpace") {
            context("same space") {
                let randomPoint = CGPoint(x: random(), y: random())
                let randomSize = CGSize(width: random(), height: random())
                let randomRect = CGRect(origin: randomPoint, size: randomSize)

                it("should not change") {
                    expect(imageView.convertPoint(randomPoint, fromCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertPoint(randomPoint, toCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertRect(randomRect, fromCoordinateSpace: imageView)) == randomRect
                    expect(imageView.convertRect(randomRect, toCoordinateSpace: imageView)) == randomRect
                }
            }
        }

        describe("imageCoordinatedSpace") {
            context("same space") {
                it("should not change") {
                    let imageSpace = imageView.imageCoordinatedSpace()
                    expect(imageSpace.convertPoint(CGPointZero, fromCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertRect(CGRectZero, fromCoordinateSpace: imageView)) == CGRectZero
                    expect(imageSpace.convertRect(CGRectZero, toCoordinateSpace: imageView)) == CGRectZero
                }
            }

            context("scale") {
                var imageSpace : UICoordinateSpace!
                var imageSize : CGSize!
                var viewSize  : CGSize!
                var widthRatio : CGFloat!
                var heightRatio : CGFloat!
                let imagePoint = CGPointZero

                beforeEach {
                    let square = CGSize(width: 100, height: 100)
                    imageView.bounds = CGRect(origin: CGPointZero, size: square)
                    imageSpace = imageView.imageCoordinatedSpace()

                    imageSize = image.size
                    viewSize  = imageView.bounds.size
                    widthRatio = viewSize.width / imageSize.width
                    heightRatio = viewSize.height / imageSize.height
                }

                context("scale to fill") {
                    beforeEach {
                        imageView.contentMode = .ScaleToFill
                    }

                    it("should scale image to the view size") {
                        var viewPoint = imagePoint
                        viewPoint.x *= widthRatio
                        viewPoint.y *= heightRatio

                        expect(imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)) == viewPoint
                    }
                }


                context("aspect fill") {
                    beforeEach {
                        imageView.contentMode = .ScaleAspectFill
                    }
                    it("should be scale to maximize ratio") {
                        let scale = max(widthRatio, heightRatio)
                        var viewPoint = imagePoint
                        viewPoint.x *= scale
                        viewPoint.y *= scale

                        viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2
                        viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2

                        expect(imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)) == viewPoint
                    }
                }

                context("aspect fit") {
                    beforeEach {
                        imageView.contentMode = .ScaleAspectFit
                    }
                    it("should scale image to minimize") {
                        let scale = min(widthRatio, heightRatio)
                        var viewPoint = imagePoint
                        viewPoint.x *= scale
                        viewPoint.y *= scale

                        viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2
                        viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2
                        
                        expect(imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)) == viewPoint
                        
                    }
                }
            }
        }
    }
}
