//
//  ViewContentModeTransformer+UIView.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/14/16.
//
//

extension UIView {
    var viewContentModeTransformer: ViewContentModeTransformer {
        return .init(contentMode: contentMode,
                     sizeTransformer: .init(boundsSize: bounds.size,
                                            contentSize: intrinsicContentSize))
    }
}

extension ViewContentModeTransformer {
    func transform() -> CGAffineTransform {
        return sizeTransformer.isIdentity() ? .identity : contentToViewTransform()
    }

    func coordinateSpace(basedOn space: UICoordinateSpace) -> UICoordinateSpace {
        return TransformedCoordinateSpace(size: sizeTransformer.contentSize,
                                          converter: .init(transform: transform(),
                                                           reference: space))
    }
}
