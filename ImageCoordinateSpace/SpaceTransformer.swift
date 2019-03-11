//
//  SpaceTransformer.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 3/11/19.
//

import Foundation

struct SpaceTransformer {
    let transform: CGAffineTransform
    let reference: UICoordinateSpace

    func invertedTransform() -> CGAffineTransform {
        return transform.inverted()
    }
}
