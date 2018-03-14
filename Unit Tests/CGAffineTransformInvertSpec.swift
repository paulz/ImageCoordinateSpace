import Quick
import Nimble

class CGAffineTransformInvertSpec: QuickSpec {
    override func spec() {
        describe("invert transform") {
            var modified = CGAffineTransform.identity

            afterEach {
                let invert = modified.inverted()
                let reverted = modified.concatenating(invert)
                expect(reverted) ≈ CGAffineTransform.identity
            }

            context("concatenating inverted") {

                it("should revert scale") {
                    modified = CGAffineTransform(scaleX: 2, y: 3)
                }

                it("should revert translate") {
                    modified = CGAffineTransform(translationX: 100, y: 200)
                }

                it("should revert translate and scale") {
                    let translation = CGAffineTransform(translationX: 100, y: 200)
                    modified = translation.scaledBy(x: 2, y: 3)
                }

                it("should revert scale and translate") {
                    let scale = CGAffineTransform(scaleX: 2, y: 3)
                    modified = scale.translatedBy(x: 200, y: 300)
                }

            }

        }
    }
}
