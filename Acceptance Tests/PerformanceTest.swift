//
//  PerformanceTest.swift
//  Acceptance Tests
//
//  Created by Paul Zabelin on 3/19/19.
//

import XCTest

class PerformanceTest: XCTestCase {
    var view: UIImageView!

    override func setUp() {
        view = UIImageView(frame: CGRect(x: 10, y: 20, width: 30, height: 40))
        view.image = UIImage.testImage(CGSize(width: 145, height: 109))
        view.contentMode = .scaleAspectFit
    }

    func testPerformanceContentSpace() {
        measure {
            10000.times {
                _ = view.contentSpace()
            }
        }
    }

    func testPerformanceConvert() {
        let space = view.contentSpace()
        measure {
            10000.times {
                _ = space.convert(CGPoint(x: 1, y: 1), to: view)
            }
        }
    }

    func testPerformanceConvertReverse() {
        let space = view.contentSpace()
        measure {
            10000.times {
                _ = space.convert(CGPoint(x: 1, y: 1), from: view)
            }
        }
    }

    func testPerformanceContentToBoundsTransform() {
        measure {
            10000.times {
                _ = view.contentToBoundsTransform()
            }
        }
    }

}
