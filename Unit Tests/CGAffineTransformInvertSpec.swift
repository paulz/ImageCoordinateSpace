import Quick
import Nimble

internal class CGAffineTransformInvertSpec: QuickSpec {
    override func spec() {
        describe("concatenating inverted transform") {
            let anyTransform: [CGAffineTransform] = [.init(scaleX: .nextRandom(), y: .nextRandom()),
                                                     .identity,
                                                     .init(translationX: .nextRandom(), y: .nextRandom()),
                                                     .init(rotationAngle: .nextRandom()),
                                                     .nextRandom()]
            anyTransform.forEach { transform in
                it("\(transform) should become identity") {
                    let invert = transform.inverted()
                    let reverted = transform.concatenating(invert)
                    expect(reverted) ≈ CGAffineTransform.identity
                }
            }
        }
    }
}
