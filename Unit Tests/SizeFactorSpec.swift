import Quick
import Nimble
@testable import ImageCoordinateSpace

class SizeFactorSpec: QuickSpec {
    override func spec() {
        describe(SizeFactor.self) {
            context(SizeFactor.init(height:width:)) {
                it("should create size factor") {
                    let sizeFactor = SizeFactor(height: ScaleFactor.right, width: ScaleFactor.left)
                    expect(sizeFactor.height) == ScaleFactor.right
                    expect(sizeFactor.width) == ScaleFactor.left
                }

                context("default arguments") {
                    it("should be center for both height and width") {
                        let sizeFactor = SizeFactor()
                        expect(sizeFactor.height) == ScaleFactor.center
                        expect(sizeFactor.width) == ScaleFactor.center
                    }
                }
            }
        }
    }
}
