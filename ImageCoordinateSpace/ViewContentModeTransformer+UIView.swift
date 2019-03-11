//
//  ViewContentModeTransformer+UIView.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

extension UIView {
    var viewContentModeTransformer: ViewContentModeTransformer {
        let transformer = SizeTransformer(boundsSize: bounds.size, contentSize: intrinsicContentSize)
        return ViewContentModeTransformer(contentMode: contentMode, sizeTransformer: transformer)
    }
}

extension ViewContentModeTransformer {
    func transform() -> CGAffineTransform {
        return sizeTransformer.isIdentity() ? .identity : contentToViewTransform()
    }

    func coordinateSpace(basedOn space: UICoordinateSpace) -> UICoordinateSpace {
        let converter = Converter(transform: transform(), reference: space)
        return TransformedCoordinateSpace(size: sizeTransformer.contentSize, converter: converter)
    }
}
