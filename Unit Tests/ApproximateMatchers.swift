//
//  ApproximateMatchers.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/17/16.
//
//

import Nimble
import UIKit

func beVeryCloseTo(_ expectedValue: CGRect!) -> Predicate <CGRect> {
    return Predicate.simpleNilable("equal <\(expectedValue.debugDescription)>", matcher: { actualExpression -> PredicateStatus in
        let actual = try actualExpression.evaluate()!
        let delta : CGFloat = 0.000002
        return PredicateStatus(bool:
            abs(actual.origin.x - expectedValue.origin.x) < delta &&
            abs(actual.origin.y - expectedValue.origin.y) < delta &&
            abs(actual.size.width - expectedValue.size.width) < delta &&
            abs(actual.size.height - expectedValue.size.height) < delta
        )
    })
}

func beVeryCloseTo(_ expectedValue: CGPoint!) -> Predicate <CGPoint> {
    return Predicate.simpleNilable("equal <\(expectedValue.debugDescription)>", matcher: { actualExpression -> PredicateStatus in
        let actual = try actualExpression.evaluate()!
        let delta : CGFloat = 0.000002
        return PredicateStatus(bool:
            abs(actual.x - expectedValue.x) < delta &&
            abs(actual.y - expectedValue.y) < delta
        )
    })
}
