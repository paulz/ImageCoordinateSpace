import Quick
import Nimble

class UIImageView_ImageCoordinatedSpaceSpec: QuickSpec {
    override func spec() {
        let image = UIImage(named: "rose")
        let imageView = UIImageView(image: image)

        describe("view UICoordinateSpace") {
            context("same space") {
                it("should not change") {
                    expect(imageView.convertPoint(CGPointZero, fromCoordinateSpace: imageView)) == CGPointZero
                    expect(imageView.convertPoint(CGPointZero, toCoordinateSpace: imageView)) == CGPointZero
                    expect(imageView.convertRect(CGRectZero, fromCoordinateSpace: imageView)) == CGRectZero
                    expect(imageView.convertRect(CGRectZero, toCoordinateSpace: imageView)) == CGRectZero
                }
            }
        }

        describe("imageCoordinatedSpace") {
            context("same space") {
                it("should not change") {
                    let imageSpace = imageView.imageCoordinatedSpace()
                    expect(imageSpace.convertPoint(CGPointZero, fromCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)) == CGPointZero
                    expect(imageSpace.convertRect(CGRectZero, fromCoordinateSpace: imageView)) == CGRectZero
                    expect(imageSpace.convertRect(CGRectZero, toCoordinateSpace: imageView)) == CGRectZero
                }
            }
        }
    }
}
