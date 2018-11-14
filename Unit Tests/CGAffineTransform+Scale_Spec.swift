import Quick
import Nimble
@testable import ImageCoordinateSpace

class CGAffineTransform_Scale_Spec: QuickSpec {
    override func spec() {
        describe(CGAffineTransform.self) {
            context(\CGAffineTransform.scaleX) {
                it("should be multiplier for X axis") {
                    let transform = CGAffineTransform(scaleX: 123.456, y: CGFloat.nextRandom())
                    expect(transform.scaleX) == 123.456
                }
            }

            context(\CGAffineTransform.scaleY) {
                it("should be multiplier for Y axis") {
                    let transform = CGAffineTransform(scaleX: CGFloat.nextRandom(), y: 987.654)
                    expect(transform.scaleY) == 987.654
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
