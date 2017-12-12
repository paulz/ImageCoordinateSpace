import Quick
import Nimble

class CGAffineTransformInvertSpec: QuickSpec {
    override func spec() {
        describe("invert transform") {
            it("should revert scale") {
                let scaled = CGAffineTransform(scaleX: 2, y: 3)
                let invert = scaled.inverted()
                let inverted = scaled.concatenating(invert)
                expect(inverted) == CGAffineTransform.identity
            }

            it("should revert translate") {
                let translation = CGAffineTransform(translationX: 100, y: 200)
                let invert = translation.inverted()
                let reverted = translation.concatenating(invert)
                expect(reverted) == CGAffineTransform.identity
            }

            it("should revert translate and scale") {
                let translation = CGAffineTransform(translationX: 100, y: 200)
                let scaledTranslation = translation.scaledBy(x: 2, y: 3)
                let invert = scaledTranslation.inverted()
                let reverted = scaledTranslation.concatenating(invert)
                expect(reverted) == CGAffineTransform.identity
            }

            it("should revert scale and translate") {
                let scale = CGAffineTransform(scaleX: 2, y: 3)
                let translated = scale.translatedBy(x: 200, y: 300)
                let invert = translated.inverted()
                let reverted = translated.concatenating(invert)
                expect(reverted) == CGAffineTransform.identity
            }
        }
    }
}
