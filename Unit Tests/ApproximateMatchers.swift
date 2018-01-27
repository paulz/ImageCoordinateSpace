//
//  ApproximateMatchers.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import Nimble
import UIKit

func beCloseTo(_ expectedValue: CGRect!, within delta: Double = 0.00001) -> Predicate <CGRect> {
    return Predicate.simple("equal <\(expectedValue.debugDescription)>") { actualExpression in
        let actual = try actualExpression.evaluate()!
        let pointDelta = CGFloat(delta)
        return PredicateStatus(bool:
            abs(actual.origin.x - expectedValue.origin.x) < pointDelta &&
                abs(actual.origin.y - expectedValue.origin.y) < pointDelta &&
                abs(actual.size.width - expectedValue.size.width) < pointDelta &&
                abs(actual.size.height - expectedValue.size.height) < pointDelta
        )
    }
}

func beCloseTo(_ expectedValue: CGPoint!, within delta: Double = 0.00001) -> Predicate <CGPoint> {
    return Predicate.simple("equal <\(expectedValue.debugDescription)>") { actualExpression in
        let actual = try actualExpression.evaluate()!
        let pointDelta = CGFloat(delta)
        return PredicateStatus(bool:
            abs(actual.x - expectedValue.x) < pointDelta &&
                abs(actual.y - expectedValue.y) < pointDelta
        )
    }
}

public func ≈(lhs: Expectation<CGRect>, rhs: CGRect) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<CGPoint>, rhs: CGPoint) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<CGRect>, rhs: (expected: CGRect, delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ±(lhs: CGRect, rhs: Double) -> (expected: CGRect, delta: Double) {
    return (expected: lhs, delta: rhs)
}
