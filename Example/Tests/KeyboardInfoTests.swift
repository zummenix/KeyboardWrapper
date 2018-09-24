import UIKit
import XCTest
import KeyboardWrapper

class KeyboardInfoTests: XCTestCase {

    func testAnimationCurve() {
        let expectedCurves: [UIViewAnimationCurve] = [.easeInOut, .easeIn, .easeOut, .linear]

        let curves = expectedCurves.map { c in
            KeyboardInfo(info: [UIKeyboardAnimationCurveUserInfoKey: c.rawValue], state: .willShow).animationCurve
        }
        XCTAssertEqual(curves, expectedCurves)
    }

    func testAnimationOptions() {
        let curves: [UIViewAnimationCurve] = [.easeInOut, .easeIn, .easeOut, .linear]

        let options = curves.map { c in
            KeyboardInfo(info: [UIKeyboardAnimationCurveUserInfoKey: c.rawValue], state: .willShow).animationOptions
        }
        XCTAssertEqual(options, [.curveEaseInOut, .curveEaseIn, .curveEaseOut, .curveLinear])
    }

    func testAnimationOptionsWithHiddenAnimationCurveCase() {
        let curves: [UIViewAnimationCurve] = [.easeInOut, .easeIn, .easeOut, .linear]
        let rawCurves: [Int] = curves.map({ $0.rawValue }) + [7]

        let options = rawCurves.map { c in
            KeyboardInfo(info: [UIKeyboardAnimationCurveUserInfoKey: c], state: .willShow).animationOptions
        }
        XCTAssertEqual(options, [.curveEaseInOut, .curveEaseIn, .curveEaseOut, .curveLinear, .curveEaseInOut])
    }
}
