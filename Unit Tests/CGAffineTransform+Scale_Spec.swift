import Quick
import Nimble
@testable import ImageCoordinateSpace

class CGAffineTransform_Scale_Spec: QuickSpec {
    override func spec() {
        describe(CGAffineTransform.self) {
            context(\CGAffineTransform.scale) {
                it("should be multiplier for X and Y axis") {
                    let transform = CGAffineTransform(scaleX: 123.456, y: 987.654)
                    expect(transform.scale.0) == 123.456
                    expect(transform.scale.1) == 987.654
                }
            }

            context(CGAffineTransform.init(scaleTo:from:)) {
                it("should create tranform that will scale from one size to another") {
                    let from = CGSize.nextRandom()
                    let to = CGSize.nextRandom()
                    let transform = CGAffineTransform(scaleTo: to, from: from)
                    expect(from.applying(transform)) ≈ to ± 0.0001
                }
            }
        }
    }
}
