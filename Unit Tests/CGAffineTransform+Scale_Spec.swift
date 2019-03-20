import Quick
import Nimble
@testable import ImageCoordinateSpace

class CGAffineTransform_Scale_Spec: QuickSpec {
    override func spec() {
        describe(CGAffineTransform.self) {
            context(CGAffineTransform.scale) {
                it("should pass X and Y to block and return block result") {
                    let transform = CGAffineTransform(scaleX: 2, y: 3)
                    expect(transform.scale(using: {
                        expect($0) == 2
                        expect($1) == 3
                        return 5
                    })) == 5
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
