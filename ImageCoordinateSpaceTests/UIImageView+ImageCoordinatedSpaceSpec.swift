import Quick
import Nimble

class UIImageView_ImageCoordinatedSpaceSpec: QuickSpec {
    override func spec() {
        let image = UIImage(named: "rose")
        let imageView = UIImageView(image: image)
        describe("imageCoordinatedSpace") {
            context("same space") {
                it("should not change") {
                    let converted = imageView.convertPoint(CGPointZero, fromCoordinateSpace: imageView)
                    expect(converted) == CGPointZero
                }
            }
        }
    }
}
