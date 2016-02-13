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

            var imageSpace : UICoordinateSpace!
            var imageSize : CGSize!
            var viewSize  : CGSize!
            var widthRatio : CGFloat!
            var heightRatio : CGFloat!
            let imagePoint = CGPointZero
            var viewPoint : CGPoint!

            beforeEach {
                let square = CGSize(width: 100, height: 100)
                imageView.bounds = CGRect(origin: CGPointZero, size: square)
                imageSpace = imageView.imageCoordinatedSpace()

                imageSize = image.size
                viewSize  = imageView.bounds.size
                widthRatio = viewSize.width / imageSize.width
                heightRatio = viewSize.height / imageSize.height

                viewPoint = imagePoint
            }

            func expectViewPointMatchImagePoint(file: String = __FILE__, line: UInt = __LINE__) {
                expect(imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView), file:file, line: line) == viewPoint
            }

            context("top left") {
                beforeEach {
                    imageView.contentMode = .TopLeft
                }

                it("should be same as view") {
                    expectViewPointMatchImagePoint()
                }
            }

            context("center") {
                beforeEach {
                    imageView.contentMode = .Center
                }

                it("should not stretch the image") {
                    viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                    viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                    expectViewPointMatchImagePoint()
                }
            }

            context("scale") {
                context("scale to fill") {
                    beforeEach {
                        imageView.contentMode = .ScaleToFill
                    }

                    it("should scale image to the view size") {
                        viewPoint.x *= widthRatio
                        viewPoint.y *= heightRatio
                        expectViewPointMatchImagePoint()
                    }
                }


                context("aspect fill") {
                    beforeEach {
                        imageView.contentMode = .ScaleAspectFill
                    }
                    it("should be scale to maximize ratio") {
                        let scale = max(widthRatio, heightRatio)
                        viewPoint.x *= scale
                        viewPoint.y *= scale

                        viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2
                        viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2

                        expectViewPointMatchImagePoint()
                    }
                }

                context("aspect fit") {
                    beforeEach {
                        imageView.contentMode = .ScaleAspectFit
                    }
                    it("should scale image to minimize") {
                        let scale = min(widthRatio, heightRatio)
                        viewPoint.x *= scale
                        viewPoint.y *= scale

                        viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2
                        viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2
                        
                        expectViewPointMatchImagePoint()
                    }
                }
            }
        }
    }
}
