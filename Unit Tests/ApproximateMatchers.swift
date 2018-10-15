//
//  ApproximateMatchers.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import Nimble
import UIKit

public protocol FlatArrayConvertible {
    var flattened: [CGFloat] {get}
}

extension CGAffineTransform: FlatArrayConvertible {
    public var flattened: [CGFloat] { get { return [a, b, c, d, tx, ty]}}
}
extension CGPoint: FlatArrayConvertible {
    public var flattened: [CGFloat] { get { return [x, y]}}
}
extension CGSize: FlatArrayConvertible {
    public var flattened: [CGFloat] { get { return [width, height]}}
}
extension CGRect: FlatArrayConvertible {
    public var flattened: [CGFloat] { get { return origin.flattened + size.flattened}}
}


func beCloseTo(_ expectedValue: FlatArrayConvertible!, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate <FlatArrayConvertible> {
    return Predicate.simple("equal <\(expectedValue.debugDescription)>") { actualExpression in
        let actual = try actualExpression.evaluate()!
        let expected = expectedValue.flattened
        for (index, m) in actual.flattened.enumerated() {
            if abs(m - expected[index]) > delta {
                return .doesNotMatch
            }
        }
        return .matches
    }
}

public func ≈(lhs: Expectation<FlatArrayConvertible>, rhs: FlatArrayConvertible) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<FlatArrayConvertible>, rhs: (expected: FlatArrayConvertible, delta: CGFloat)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ±(lhs: FlatArrayConvertible, rhs: CGFloat) -> (expected: FlatArrayConvertible, delta: CGFloat) {
    return (expected: lhs, delta: rhs)
}
