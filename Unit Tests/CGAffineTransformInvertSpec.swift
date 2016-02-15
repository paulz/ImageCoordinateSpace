import Quick
import Nimble

class CGAffineTransformInvertSpec: QuickSpec {
    override func spec() {
        describe("invert transform") {
            it("should revert scale") {
                let scaled = CGAffineTransformMakeScale(2, 3)
                let invert = CGAffineTransformInvert(scaled)
                let inverted = CGAffineTransformConcat(scaled, invert)
                expect(CGAffineTransformEqualToTransform(inverted, CGAffineTransformIdentity)) == true
            }

            it("should revert translate") {
                let translation = CGAffineTransformMakeTranslation(100, 200)
                let invert = CGAffineTransformInvert(translation)
                let reverted = CGAffineTransformConcat(translation, invert)
                expect(CGAffineTransformEqualToTransform(reverted, CGAffineTransformIdentity)) == true
            }

            it("should revert translate and scale") {
                let translation = CGAffineTransformMakeTranslation(100, 200)
                let scaledTranslation = CGAffineTransformScale(translation, 2, 3)
                let invert = CGAffineTransformInvert(scaledTranslation)
                let reverted = CGAffineTransformConcat(scaledTranslation, invert)
                expect(CGAffineTransformEqualToTransform(reverted, CGAffineTransformIdentity)) == true
            }

            it("should revert scale and translate") {
                let scale = CGAffineTransformMakeScale(2, 3)
                let translated = CGAffineTransformScale(scale, 200, 300)
                let invert = CGAffineTransformInvert(translated)
                let reverted = CGAffineTransformConcat(translated, invert)
                expect(CGAffineTransformEqualToTransform(reverted, CGAffineTransformIdentity)) == true
            }
        }
    }
}
