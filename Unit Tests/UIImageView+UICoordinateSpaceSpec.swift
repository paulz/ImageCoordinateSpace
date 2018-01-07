import Quick
import Nimble
import ImageCoordinateSpace
import CoreGraphics

func random() -> Int {
    return Int(arc4random())
}

class UIImageView_imageCoordinateSpaceSpec: QuickSpec {
    override func spec() {
        let testBundle = Bundle(for: type(of: self))
        let image = UIImage(named: "rose", in: testBundle, compatibleWith: nil)!

        var imageView: UIImageView!

        beforeEach {
            imageView = UIImageView(image: image)
        }

        let randomPoint = CGPoint(x: Int(arc4random()), y: Int(arc4random()))
        let randomSize = CGSize(width: Int(arc4random()), height: Int(arc4random()))
        let randomRect = CGRect(origin: randomPoint, size: randomSize)

        describe("view UICoordinateSpace") {
            context("same space") {
                it("should not change") {
                    expect(imageView.convert(randomPoint, from: imageView)) == randomPoint
                    expect(imageView.convert(randomPoint, to: imageView)) == randomPoint
                    expect(imageView.convert(randomRect, from: imageView)) == randomRect
                    expect(imageView.convert(randomRect, to: imageView)) == randomRect
                }
            }
        }

        describe(String(describing:UIView.contentToBoundsTransform)) {
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
                    expect(imageView.contentToBoundsTransform()) == scaleDown
                }
            }

            context("random transform") {
                it("should be equal") {
                    let transform = CGAffineTransform(scaleX: randomPoint.x/(randomPoint.x+randomPoint.y),
                                                      y: randomPoint.y/(randomPoint.x+randomPoint.y))
                    imageView.contentMode = .scaleToFill
                    imageView.bounds = imageView.bounds.applying(transform)
                    expect(imageView.contentToBoundsTransform()) == transform
                }
            }

        }

        describe("contentSpace()") {
            var imageSpace: UICoordinateSpace!

            beforeEach {
                imageSpace = imageView.contentSpace()
            }

            context("zero") {
                it("should return zero") {
                    expect(imageSpace.convert(CGPoint.zero, from: imageView)) == CGPoint.zero
                    expect(imageSpace.convert(CGPoint.zero, to: imageView)) == CGPoint.zero
                    expect(imageSpace.convert(CGRect.zero, from: imageView)) == CGRect.zero
                    expect(imageSpace.convert(CGRect.zero, to: imageView)) == CGRect.zero
                }
            }

            context("bounds") {
                it("should be size of image") {
                    expect(imageSpace.bounds.size) == image.size
                    expect(imageSpace.bounds.origin) == CGPoint.zero
                }
            }

            context("no image") {
                var noImageSpace: UICoordinateSpace!
                var foreignSpace: UICoordinateSpace!


                beforeEach {
                    let frame = CGRect(x: random(), y: random(), width: random(), height: random())
                    let noImageView = UIImageView(frame: frame)
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
                            expect(noImageSpace.convert(randomRect, from: noImageSpace)).to(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convert(randomRect, to: noImageSpace)).to(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convert(randomPoint, from:noImageSpace)).to(beVeryCloseTo(randomPoint))
                            expect(noImageSpace.convert(randomPoint, to: noImageSpace)).to(beVeryCloseTo(randomPoint))
                        }
                    }
                    context("within foreign space") {
                        it("should not convert") {
                            expect(noImageSpace.convert(randomRect, from: foreignSpace)).notTo(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convert(randomRect, to: foreignSpace)).notTo(beVeryCloseTo(randomRect))
                            expect(noImageSpace.convert(randomPoint, from: foreignSpace)).notTo(beVeryCloseTo(randomPoint))
                            expect(noImageSpace.convert(randomPoint, to: foreignSpace)).notTo(beVeryCloseTo(randomPoint))
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

            context("top left") {
                beforeEach {
                    imageView.contentMode = .topLeft
                }

                it("should be same as view") {
                    expectViewPointMatchImagePoint()
                }
            }

            context("left") {
                beforeEach {
                    imageView.contentMode = .left
                }

                it("should change y to the center") {
                    viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                    expectViewPointMatchImagePoint()
                }
            }

            context("right") {
                beforeEach {
                    imageView.contentMode = .right
                }

                it("should change x as top right, y as as left") {
                    viewPoint.x += viewSize.width - imageSize.width
                    viewPoint.y += viewSize.height / 2 - imageSize.height / 2
                    expectViewPointMatchImagePoint()
                }
            }

            context("top right") {
                beforeEach {
                    imageView.contentMode = .topRight
                }

                it("should change x by widths difference") {
                    viewPoint.x += viewSize.width - imageSize.width
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom left") {
                beforeEach {
                    imageView.contentMode = .bottomLeft
                }

                it("should change only y by height difference") {
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom right") {
                beforeEach {
                    imageView.contentMode = .bottomRight
                }

                it("should change both x and y by size difference") {
                    viewPoint.x += viewSize.width - imageSize.width
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("bottom") {
                beforeEach {
                    imageView.contentMode = .bottom
                }

                it("should change both x and y by size difference") {
                    viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                    viewPoint.y += viewSize.height - imageSize.height
                    expectViewPointMatchImagePoint()
                }
            }

            context("top") {
                beforeEach {
                    imageView.contentMode = .top
                }

                it("should change only x to the center") {
                    viewPoint.x += viewSize.width / 2  - imageSize.width  / 2
                    expectViewPointMatchImagePoint()
                }
            }


            context("center") {
                beforeEach {
                    imageView.contentMode = .center
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
                        imageView.contentMode = .scaleToFill
                    }

                    it("should scale image to the view size") {
                        viewPoint.x *= widthRatio
                        viewPoint.y *= heightRatio
                        expectViewPointMatchImagePoint()
                    }
                }


                context("aspect fill") {
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

                context("aspect fit") {
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
