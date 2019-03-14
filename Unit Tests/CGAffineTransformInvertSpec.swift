import Quick
import Nimble

internal class CGAffineTransformInvertSpec: QuickSpec {
    override func spec() {
        sharedExamples("reverts to identity") { sharedContext in
            it("should be identity") {
                let transform = sharedContext()["transform"] as! CGAffineTransform
                let invert = transform.inverted()
                let reverted = transform.concatenating(invert)
                expect(reverted) ≈ CGAffineTransform.identity
            }
        }

        describe("any transform become identity") {
            context("concatenating inverted") {
                let anyTransform: [CGAffineTransform] = [.init(scaleX: 2, y: 3),
                                                         .identity,
                                                         .init(translationX: 100, y: 200),
                                                         .nextRandom()]
                anyTransform.forEach { transform in
                    itBehavesLike("reverts to identity") {["transform":transform]}
                }
            }
        }
    }
}
