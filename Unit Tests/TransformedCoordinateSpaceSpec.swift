import Quick
import Nimble
@testable import ImageCoordinateSpace

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
        describe(String(describing: UICoordinateSpace.self)) {
            context(String(describing: CGAffineTransform.identity)) {
                it("should convert with no changes") {
                    let view = UIView(frame: CGRect.nextRandom())
                    let space = TransformedCoordinateSpace(size: CGSize.nextRandom(),
                                                           transform: {CGAffineTransform.identity},
                                                           destination: view)
                    let point = CGPoint.nextRandom()
                    let destination = UIView(frame: CGRect.nextRandom())

                    expect(space.convert(point, to: destination)) == view.convert(point, to: destination)
                    expect(space.convert(point, from: destination)) == view.convert(point, from: destination)

                    let rect = CGRect.nextRandom()
                    expect(space.convert(rect, to: destination)) == view.convert(rect, to: destination)
                    expect(space.convert(rect, from: destination)) == view.convert(rect, from: destination)
                }
            }
        }
    }
}
