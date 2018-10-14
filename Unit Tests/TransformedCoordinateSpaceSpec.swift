import Quick
import Nimble
@testable import ImageCoordinateSpace

class SpaceStub: NSObject, UICoordinateSpace {
    func convert(_ point: CGPoint, to coordinateSpace: UICoordinateSpace) -> CGPoint {
        fatalError()
    }

    func convert(_ point: CGPoint, from coordinateSpace: UICoordinateSpace) -> CGPoint {
        fatalError()
    }

    func convert(_ rect: CGRect, to coordinateSpace: UICoordinateSpace) -> CGRect {
        fatalError()
    }

    func convert(_ rect: CGRect, from coordinateSpace: UICoordinateSpace) -> CGRect {
        fatalError()
    }

    var bounds: CGRect = CGRect.init(x: Double.nan, y: Double.nan, width: Double.nan, height: Double.nan)
}

private class TransformedCoordinateSpaceSpec: QuickSpec {
    override func spec() {
        describe(String(describing: TransformedCoordinateSpace.init(original:transform:bounds:))) {
            context(String(describing: \TransformedCoordinateSpace.invertedTransform)) {
                var transform: CGAffineTransform!
                beforeEach {
                    transform = CGAffineTransform.nextRandom()
                }

                it("should create inverted transform to be inverted transform") {
                    let space = TransformedCoordinateSpace(original: UIView(),
                                                           transform: {transform},
                                                           bounds: CGRect.zero)
                    expect(space.invertedTransform) == transform.inverted()
                }
            }
        }
        describe(String(describing: TransformedCoordinateSpace.init(size:transform:destination:))) {
            context(String(describing: \UICoordinateSpace.bounds)) {
                it("should be zero to size") {
                    let size = CGSize.nextRandom()
                    let space = TransformedCoordinateSpace(size: size,
                                                           transform: {CGAffineTransform.nextRandom()},
                                                           destination: SpaceStub())
                    expect(space.bounds) == CGRect(origin: CGPoint.zero, size: size)
                }
            }
        }

        describe(String(describing: UICoordinateSpace.self)) {
            context("mock space") {
                let anyTransform = CGAffineTransform.nextRandom()
                let anySpace = SpaceStub()
                let anySize = CGSize.nextRandom()

                context(String(describing: CGRect.self)) {
                    class ConvertRectToMockSpace: SpaceStub {
                        var result: CGRect = CGRect.nextRandom()
                        var argument: CGRect?

                        override func convert(_ rect: CGRect, to coordinateSpace: UICoordinateSpace) -> CGRect {
                            argument = rect
                            return result
                        }
                    }
                    let rect = CGRect.nextRandom()
                    let mock = ConvertRectToMockSpace()

                    context("convert to space") {
                        let space = TransformedCoordinateSpace(size: anySize,
                                                               transform: {anyTransform},
                                                               destination: mock)

                        it("should convert using destination space") {
                            let result = space.convert(rect, to: anySpace)
                            expect(result) == mock.result
                        }

                        it("should convert rect after applying transform") {
                            let transformedPoint = rect.applying(anyTransform)
                            _ = space.convert(rect, to: anySpace)
                            expect(mock.argument) == transformedPoint
                        }
                    }

                    context("convert from space") {
                        let space = TransformedCoordinateSpace(size: anySize,
                                                               transform: {anyTransform},
                                                               destination: anySpace)

                        it("should convert rect after applying inverted transform") {
                            let result = space.convert(rect, from: mock)
                            expect(result) == mock.result.applying(anyTransform.inverted())
                        }

                        it("should convert using rect as argument") {
                            _ = space.convert(rect, from: mock)
                            expect(mock.argument) == rect
                        }
                    }

                }

                context(String(describing: CGPoint.self)) {
                    class ConvertPointToMockSpace: SpaceStub {
                        var result: CGPoint = CGPoint.nextRandom()
                        var argument: CGPoint?

                        override func convert(_ point: CGPoint, to coordinateSpace: UICoordinateSpace) -> CGPoint {
                            argument = point
                            return result
                        }
                    }
                    let point = CGPoint.nextRandom()
                    let mock = ConvertPointToMockSpace()

                    context("convert to space") {
                        let space = TransformedCoordinateSpace(size: anySize,
                                                               transform: {anyTransform},
                                                               destination: mock)
                        it("should use destination space to convert") {
                            let result = space.convert(point, to: anySpace)
                            expect(result) == mock.result
                        }

                        it("should use as argument the point after applying transform") {
                            let transformedPoint = point.applying(anyTransform)
                            _ = space.convert(point, to: anySpace)
                            expect(mock.argument) == transformedPoint
                        }
                    }

                    context("convert from space") {
                        let space = TransformedCoordinateSpace(size: anySize,
                                                               transform: {anyTransform},
                                                               destination: anySpace)

                        it("should convert to applying inverted transform") {
                            let result = space.convert(point, from: mock)
                            expect(result) == mock.result.applying(anyTransform.inverted())
                        }

                        it("should convert to using point as argument") {
                            _ = space.convert(point, from: mock)
                            expect(mock.argument) == point
                        }
                    }
                }
            }
        }
    }
}
