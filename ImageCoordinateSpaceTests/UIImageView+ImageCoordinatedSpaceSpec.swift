import Quick
import Nimble

class UIImageView_ImageCoordinatedSpaceSpec: QuickSpec {
    override func spec() {
        let image = UIImage(named: "rose")!
        let imageView = UIImageView(image: image)

        describe("view UICoordinateSpace") {
            context("same space") {
                let randomPoint = CGPoint(x: random(), y: random())
                let randomSize = CGSize(width: random(), height: random())
                let randomRect = CGRect(origin: randomPoint, size: randomSize)

                it("should not change") {
                    expect(imageView.convertPoint(randomPoint, fromCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertPoint(randomPoint, toCoordinateSpace: imageView)) == randomPoint
                    expect(imageView.convertRect(randomRect, fromCoordinateSpace: imageView)) == randomRect
                    expect(imageView.convertRect(randomRect, toCoordinateSpace: imageView)) == randomRect
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

            context("aspect fit") {
                beforeEach {
                    let square = CGSize(width: 100, height: 100)
                    imageView.bounds = CGRect(origin: CGPointZero, size: square)
                    imageView.contentMode = .ScaleAspectFit
                }

                it("should be within the view") {
                    let imageSpace = imageView.imageCoordinatedSpace()
                    let imageSize = image.size;
                    let viewSize  = imageView.bounds.size;
                    let ratioX = viewSize.width / imageSize.width
                    let ratioY = viewSize.height / imageSize.height
                    let scale = min(ratioX, ratioY);

                    let imagePoint = CGPointZero

                    var viewPoint = imagePoint
                    viewPoint.x *= scale;
                    viewPoint.y *= scale;

                    viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2;
                    viewPoint.y += (viewSize.height  - imageSize.height  * scale) / 2;

                    expect(imageSpace.convertPoint(CGPointZero, toCoordinateSpace: imageView)) == viewPoint

                }
            }
        }
    }
}
