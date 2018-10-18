import Quick
import Nimble
@testable import ImageCoordinateSpace

class ScaleFactorSpec: QuickSpec {
    override func spec() {
        describe(ScaleFactor.self) {
            context(ScaleFactor.scale) {
                it("should multiply by scale") {
                    let scaleFactor = ScaleFactor.half
                    let scaled = scaleFactor.scale(value: 5.0)
                    expect(scaled) == 2.5
                }
            }
        }
    }
}
