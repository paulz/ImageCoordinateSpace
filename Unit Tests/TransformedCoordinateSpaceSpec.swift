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
        context(TransformedCoordinateSpace.init(size:converter:)) {
            context(\UICoordinateSpace.bounds) {
                it("should be zero to size") {
                    let size = CGSize.nextRandom()
                    let converter = Converter(transform: CGAffineTransform.nextRandom(), reference: SpaceStub())
                    let space = TransformedCoordinateSpace(size: size, converter: converter)
                    expect(space.bounds) == CGRect(origin: CGPoint.zero, size: size)
                }
            }
        }

        describe(UICoordinateSpace.self) {
            context("with mock space") {
                let anyTransform = CGAffineTransform.nextRandom()
                let anySpace = SpaceStub()
                let anySize = CGSize.nextRandom()

                func createSubject(space: UICoordinateSpace) -> TransformedCoordinateSpace {
                    let converter = Converter(transform: anyTransform, reference: space)
                    return TransformedCoordinateSpace(size: anySize, converter: converter)
                }

                context(CGRect.self) {
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
                        let subject = createSubject(space: mock)

                        it("should convert using destination space") {
                            let result = subject.convert(rect, to: anySpace)
                            expect(result) == mock.result
                        }

                        it("should convert rect after applying transform") {
                            let transformedPoint = rect.applying(anyTransform)
                            _ = subject.convert(rect, to: anySpace)
                            expect(mock.argument) == transformedPoint
                        }
                    }

                    context("convert from space") {
                        let subject = createSubject(space: anySpace)

                        it("should convert rect after applying inverted transform") {
                            let result = subject.convert(rect, from: mock)
                            expect(result) == mock.result.applying(anyTransform.inverted())
                        }

                        it("should convert using rect as argument") {
                            _ = subject.convert(rect, from: mock)
                            expect(mock.argument) == rect
                        }
                    }

                }

                context(CGPoint.self) {
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
                        let subject = createSubject(space: mock)

                        it("should use destination space to convert") {
                            let result = subject.convert(point, to: anySpace)
                            expect(result) == mock.result
                        }

                        it("should use as argument the point after applying transform") {
                            let transformedPoint = point.applying(anyTransform)
                            _ = subject.convert(point, to: anySpace)
                            expect(mock.argument) == transformedPoint
                        }
                    }

                    context("convert from space") {
                        let subject = createSubject(space: anySpace)

                        it("should convert to applying inverted transform") {
                            let result = subject.convert(point, from: mock)
                            expect(result) == mock.result.applying(anyTransform.inverted())
                        }

                        it("should convert to using point as argument") {
                            _ = subject.convert(point, from: mock)
                            expect(mock.argument) == point
                        }
                    }
                }
            }
        }
    }
}
