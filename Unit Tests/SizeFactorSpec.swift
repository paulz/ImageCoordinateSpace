import Quick
import Nimble
@testable import ImageCoordinateSpace

class SizeFactorSpec: QuickSpec {
    override func spec() {
        describe(SizeFactor.self) {
            context(SizeFactor.init(height:width:)) {
                it("should create size factor") {
                    let sizeFactor = SizeFactor(height: .right, width: .left)
                    expect(sizeFactor.height) == ScaleFactor.right.rawValue
                    expect(sizeFactor.width) == ScaleFactor.left.rawValue
                }

                context("default arguments") {
                    it("should be center for both height and width") {
                        let sizeFactor = SizeFactor(height: .center)
                        expect(sizeFactor.height) == ScaleFactor.center.rawValue
                        expect(sizeFactor.width) == ScaleFactor.center.rawValue
                    }
                }
            }
        }
    }
}
