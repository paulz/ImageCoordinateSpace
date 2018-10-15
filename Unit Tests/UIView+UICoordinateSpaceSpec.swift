import Quick
import Nimble
import ImageCoordinateSpace

private func context(_ mode: UIView.ContentMode, flags: FilterFlags = [:], closure: () -> ()) {
    context(String(describing: mode), flags: flags, closure: closure)
}

class UIView_contentSpaceSpec: QuickSpec {
    override func spec() {
        describe("UIView extension for ImageCoordinateSpace") {
            var image: UIImage!

            var imageView: UIImageView!
            var randomPoint: CGPoint!
            var randomRect: CGRect!

            beforeEach {
                image = UIImage.testImage(CGSize(width: 145, height: 109))
                imageView = UIImageView(image: image)
                randomPoint = CGPoint.nextRandom()
                randomRect = CGRect.nextRandom()
            }

            context(UIView.contentToBoundsTransform) {
                context("same sizes") {
                    it("should be identity") {
                        imageView.contentMode = .topLeft
                        expect(imageView.contentToBoundsTransform()) == CGAffineTransform.identity
                    }
                }

                context("bounds scaled down") {
                    it("should be scale transform") {
                        let scaleDown = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        imageView.contentMode = .scaleToFill
                        imageView.bounds = imageView.bounds.applying(scaleDown)
                        expect(imageView.contentToBoundsTransform()) ≈ scaleDown
                    }
                }

                context("random scale") {
                    context("scale to fill") {
                        var randomScale: CGAffineTransform!

                        beforeEach {
                            randomScale = CGAffineTransform(scaleX: CGFloat.nextRandom(),
                                                            y: CGFloat.nextRandom())
                        }

                        it("should be equal to transform") {
                            imageView.contentMode = .scaleToFill
                            imageView.bounds = imageView.bounds.applying(randomScale)
                            expect(imageView.contentToBoundsTransform()) ≈ randomScale
                        }
                    }
                }
            }

            context(UIView.contentSpace) {
                var imageSpace: UICoordinateSpace!

                beforeEach {
                    imageSpace = imageView.contentSpace()
                }

                context(CGPoint.zero) {
                    it("should return zero") {
                        expect(imageSpace.convert(CGPoint.zero, from: imageView)) == CGPoint.zero
                        expect(imageSpace.convert(CGPoint.zero, to: imageView)) == CGPoint.zero
                        expect(imageSpace.convert(CGRect.zero, from: imageView)) == CGRect.zero
                        expect(imageSpace.convert(CGRect.zero, to: imageView)) == CGRect.zero
                    }
                }

                context(\UICoordinateSpace.bounds) {
                    it("should be size of image") {
                        expect(imageSpace.bounds.size) == image.size
                        expect(imageSpace.bounds.origin) == CGPoint.zero
                    }
                }

                context("no image") {
                    var noImageSpace: UICoordinateSpace!
                    var foreignSpace: UICoordinateSpace!


                    beforeEach {
                        let noImageView = UIImageView(frame: randomRect)
                        noImageSpace = noImageView.contentSpace()
                        foreignSpace = noImageView
                    }

                    context("bounds") {
                        it("should equal to -1 rect") {
                            expect(noImageSpace.bounds) == CGRect(x: 0, y: 0, width: -1, height: -1)
                        }
                    }

                    context("convert") {
                        context("within own space") {
                            it("should return original") {
                                expect(noImageSpace.convert(randomRect, from: noImageSpace)) ≈ randomRect
                                expect(noImageSpace.convert(randomRect, to: noImageSpace)) ≈ randomRect
                                expect(noImageSpace.convert(randomPoint, from:noImageSpace)) ≈ randomPoint
                                expect(noImageSpace.convert(randomPoint, to: noImageSpace)) ≈ randomPoint
                            }
                        }
                        context("within foreign space") {
                            it("should not convert") {
                                expect(noImageSpace.convert(randomRect, from: foreignSpace)).notTo(beCloseTo(randomRect))
                                expect(noImageSpace.convert(randomRect, to: foreignSpace)).notTo(beCloseTo(randomRect))
                                expect(noImageSpace.convert(randomPoint, from: foreignSpace)).notTo(beCloseTo(randomPoint))
                                expect(noImageSpace.convert(randomPoint, to: foreignSpace)).notTo(beCloseTo(randomPoint))
                            }
                        }
                    }
                }

                var imageSize : CGSize!
                var viewSize  : CGSize!
                var widthRatio : CGFloat!
                var heightRatio : CGFloat!
                let imagePoint = CGPoint.zero
                var viewPoint : CGPoint!

                beforeEach {
                    let square = CGSize(width: 100, height: 100)
                    imageView.bounds = CGRect(origin: CGPoint.zero, size: square)
                    imageSize = image.size
                    viewSize  = imageView.bounds.size
                    widthRatio = viewSize.width / imageSize.width
                    heightRatio = viewSize.height / imageSize.height

                    viewPoint = imagePoint
                }

                func expectViewPointMatchImagePoint(_ file: String = #file, line: UInt = #line) {
                    let imageSpace = imageView.contentSpace()
                    let result = imageSpace.convert(imagePoint, to: imageView)
                    expect(result, file:file, line: line) == viewPoint
                }

                context(.topLeft) {
                    beforeEach {
                        imageView.contentMode = .topLeft
                    }

                    it("should be same as view") {
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.left) {
                    beforeEach {
                        imageView.contentMode = .left
                    }

                    it("should change y to the center") {
                        viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.right) {
                    beforeEach {
                        imageView.contentMode = .right
                    }

                    it("should change x as top right, y as as left") {
                        viewPoint.x += viewSize.width - imageSize.width
                        viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.topRight) {
                    beforeEach {
                        imageView.contentMode = .topRight
                    }

                    it("should change x by widths difference") {
                        viewPoint.x += viewSize.width - imageSize.width
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.bottomLeft) {
                    beforeEach {
                        imageView.contentMode = .bottomLeft
                    }

                    it("should change only y by height difference") {
                        viewPoint.y += viewSize.height - imageSize.height
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.bottomRight) {
                    beforeEach {
                        imageView.contentMode = .bottomRight
                    }

                    it("should change both x and y by size difference") {
                        viewPoint.x += viewSize.width - imageSize.width
                        viewPoint.y += viewSize.height - imageSize.height
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.bottom) {
                    beforeEach {
                        imageView.contentMode = .bottom
                    }

                    it("should change both x and y by size difference") {
                        viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                        viewPoint.y += viewSize.height - imageSize.height
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.top) {
                    beforeEach {
                        imageView.contentMode = .top
                    }

                    it("should change only x to the center") {
                        viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                        expectViewPointMatchImagePoint()
                    }
                }


                context(.center) {
                    beforeEach {
                        imageView.contentMode = .center
                    }

                    it("should not stretch the image") {
                        viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                        viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                        expectViewPointMatchImagePoint()
                    }
                }

                context(.scaleToFill) {
                    context("scale to fill") {
                        beforeEach {
                            imageView.contentMode = .scaleToFill
                        }

                        it("should scale image to the view size") {
                            viewPoint.x *= widthRatio
                            viewPoint.y *= heightRatio
                            expectViewPointMatchImagePoint()
                        }
                    }


                    context(.scaleAspectFill) {
                        beforeEach {
                            imageView.contentMode = .scaleAspectFill
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

                    context(.scaleAspectFit) {
                        beforeEach {
                            imageView.contentMode = .scaleAspectFit
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
}
