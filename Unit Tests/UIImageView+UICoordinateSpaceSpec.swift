import Quick
import Nimble
import ImageCoordinateSpace

class UIImageView_imageCoordinateSpaceSpec: QuickSpec {
    override func spec() {
        let testBundle = Bundle(for: type(of: self))
        let image = UIImage(named: "rose", in: testBundle, compatibleWith: nil)!

        let imageView = UIImageView(image: image)

        let randomPoint = CGPoint(x: random(), y: random())
        let randomSize = CGSize(width: random(), height: random())
        let randomRect = CGRect(origin: randomPoint, size: randomSize)

        describe("view UICoordinateSpace") {
            context("same space") {
                it("should not change") {
                    expect(imageView.convertPoint(randomPoint, fromCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertPoint(randomPoint, toCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertRect(randomRect, fromCoordinateSpace: imageView)) == randomRect
                    expect(imageView.convertRect(randomRect, toCoordinateSpace: imageView)) == randomRect
                }
            }
        }

        describe("contentSpace()") {
            context("zero") {
                let imageSpace = imageView.contentSpace()
                it("should return zero") {
                    expect(imageSpace.convertPoint(CGPointZero, fromCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertRect(CGRectZero, fromCoordinateSpace: imageView)) == CGRectZero
                    expect(imageSpace.convertRect(CGRectZero, toCoordinateSpace: imageView)) == CGRectZero
                }
            }

            context("bounds") {
                let imageSpace = imageView.contentSpace()
                it("should be size of image") {
                    expect(imageSpace.bounds.size) == image.size
                    expect(imageSpace.bounds.origin) == CGPointZero
                }
            }

            context("no image") {
                let frame = CGRect(x: random(), y: random(), width: random(), height: random())
                let noImageView = UIImageView(frame: frame)
                let noImageSpace = noImageView.contentSpace()

                context("bounds") {
                    it("should equal to -1 rect") {
                        expect(noImageSpace.bounds) == CGRectMake(0, 0, -1, -1)
                    }
                }

                context("convert") {
                    context("within own space") {
                        it("should return original") {
                            expect(noImageSpace.convertRect(randomRect, fromCoordinateSpace: noImageSpace)).to(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convertRect(randomRect, toCoordinateSpace: noImageSpace)).to(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convertPoint(randomPoint, fromCoordinateSpace:noImageSpace)).to(beVeryCloseTo(randomPoint))
                            expect(noImageSpace.convertPoint(randomPoint, toCoordinateSpace: noImageSpace)).to(beVeryCloseTo(randomPoint))
                        }
                    }
                    context("within foreign space") {
                        it("should not convert") {
                            expect(noImageSpace.convertRect(randomRect, fromCoordinateSpace: noImageView)).notTo(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convertRect(randomRect, toCoordinateSpace: noImageView)).notTo(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convertPoint(randomPoint, fromCoordinateSpace: noImageView)).notTo(beVeryCloseTo(randomPoint))
                            expect(noImageSpace.convertPoint(randomPoint, toCoordinateSpace: noImageView)).notTo(beVeryCloseTo(randomPoint))
                        }
                    }
                }
            }

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

            func expectViewPointMatchImagePoint(_ file: String = #file, line: UInt = #line) {
                let imageSpace = imageView.contentSpace()
                let result = imageSpace.convertPoint(imagePoint, toCoordinateSpace: imageView)
                expect(result, file:file, line: line) == viewPoint
            }

            context("top left") {
                beforeEach {
                    imageView.contentMode = .TopLeft
                }

                it("should be same as view") {
                    expectViewPointMatchImagePoint()
                }
            }

            context("left") {
                beforeEach {
                    imageView.contentMode = .Left
                }

                it("should change y to the center") {
                    viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                    expectViewPointMatchImagePoint()
                }
            }

            context("right") {
                beforeEach {
                    imageView.contentMode = .Right
                }

                it("should change x as top right, y as as left") {
                    viewPoint.x += viewSize.width - imageSize.width
                    viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                    expectViewPointMatchImagePoint()
                }
            }

            context("top right") {
                beforeEach {
                    imageView.contentMode = .TopRight
                }

                it("should change x by widths difference") {
                    viewPoint.x += viewSize.width - imageSize.width
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom left") {
                beforeEach {
                    imageView.contentMode = .BottomLeft
                }

                it("should change only y by height difference") {
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom right") {
                beforeEach {
                    imageView.contentMode = .BottomRight
                }

                it("should change both x and y by size difference") {
                    viewPoint.x += viewSize.width - imageSize.width
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom") {
                beforeEach {
                    imageView.contentMode = .Bottom
                }

                it("should change both x and y by size difference") {
                    viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("top") {
                beforeEach {
                    imageView.contentMode = .Top
                }

                it("should change only x to the center") {
                    viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
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
