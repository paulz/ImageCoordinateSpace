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
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform(scaleX: 2, y: 3)]}
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform.identity]}
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform(translationX: 100, y: 200)]}
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform(translationX: 100, y: 200).scaledBy(x: 2, y: 3)]}
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform(scaleX: 2, y: 3).translatedBy(x: 200, y: 300)]}
                itBehavesLike("reverts to identity") {["transform":CGAffineTransform.nextRandom()]}
            }
        }
    }
}
