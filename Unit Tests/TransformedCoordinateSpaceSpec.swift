import Quick
import Nimble
@testable import ImageCoordinateSpace

private class TransformedCoordinateSpaceSpec: QuickSpec {
    override func spec() {
        describe(String(describing: TransformedCoordinateSpace.init(original:transform:bounds:))) {
            it("should create inverted transform to be inverted transform") {
                let transform = CGAffineTransform.identity
                let space = TransformedCoordinateSpace(original: UIView(),
                                                       transform: {transform},
                                                       bounds: CGRect.zero)
                expect(space.invertedTransform) == transform.inverted()
            }
        }
    }
}
