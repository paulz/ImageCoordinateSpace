//
//  ViewContentModeTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

struct ViewContentModeTransformer {
    let contentMode: UIView.ContentMode
    let sizeTransformer: SizeTransformer

    func contentToViewTransform() -> CGAffineTransform {
        switch contentMode {
        case .scaleAspectFill:
            return sizeTransformer.centerAndScale(using: max)
        case .scaleAspectFit:
            return sizeTransformer.centerAndScale(using: min)
        case .scaleToFill, .redraw:
            return sizeTransformer.scaleToFill()
        case .topLeft:
            return .identity
        default:
            return sizeTransformer.translateAndScale(by: .init(contentMode))
        }
    }
}
