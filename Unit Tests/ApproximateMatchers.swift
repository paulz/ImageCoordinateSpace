//
//  ApproximateMatchers.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import Nimble
import UIKit

extension CGAffineTransform {
    func flattened() -> [CGFloat] {
        return [
            a, b, c, d, tx, ty
        ]
    }
}


func beCloseTo(_ expectedValue: CGRect!, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate <CGRect> {
    return Predicate.simple("equal <\(expectedValue.debugDescription)>") { actualExpression in
        let actual = try actualExpression.evaluate()!
        if String(describing: actual) == String(describing: expectedValue) {
            return .matches
        }
        let matches = abs(actual.origin.x - expectedValue.origin.x) < delta &&
            abs(actual.origin.y - expectedValue.origin.y) < delta &&
            abs(actual.size.width - expectedValue.size.width) < delta &&
            abs(actual.size.height - expectedValue.size.height) < delta
        return PredicateStatus(bool: matches)
    }
}

func beCloseTo(_ expectedValue: CGPoint!, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate <CGPoint> {
    return Predicate.simple("equal <\(expectedValue.debugDescription)>") { actualExpression in
        let actual = try actualExpression.evaluate()!
        let pointDelta = CGFloat(delta)
        return PredicateStatus(bool:
            abs(actual.x - expectedValue.x) < pointDelta &&
                abs(actual.y - expectedValue.y) < pointDelta
        )
    }
}

public func beCloseTo(_ expectedValue: CGAffineTransform, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate<CGAffineTransform> {
    let errorMessage = "be close to <\(stringify(expectedValue))> (each within \(stringify(delta)))"
    return Predicate.simple(errorMessage) { actualExpression in
        if let actual = try actualExpression.evaluate() {
            if actual == expectedValue {
                return .matches
            } else {
                let expected = expectedValue.flattened()
                for (index, m) in actual.flattened().enumerated() {
                    if fabs(m - expected[index]) > delta {
                        return .doesNotMatch
                    }
                }
                return .matches
            }
        }
        return .doesNotMatch
    }
}

public func ≈(lhs: Expectation<CGRect>, rhs: CGRect) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<CGAffineTransform>, rhs: CGAffineTransform) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<CGPoint>, rhs: CGPoint) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<CGRect>, rhs: (expected: CGRect, delta: CGFloat)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ±(lhs: CGRect, rhs: CGFloat) -> (expected: CGRect, delta: CGFloat) {
    return (expected: lhs, delta: rhs)
}
