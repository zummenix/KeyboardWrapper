import UIKit
import XCTest
import KeyboardWrapper

class KeyboardInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAnimationCurve() {
        let expectedCurves: [UIViewAnimationCurve] = [.EaseInOut, .EaseIn, .EaseOut, .Linear]

        let curves = expectedCurves.map { c in
            KeyboardInfo.fromNotificationUserInfo([UIKeyboardAnimationCurveUserInfoKey: c.rawValue], state: .WillShow).animationCurve
        }
        XCTAssertEqual(curves, expectedCurves)
    }

    func testAnimationOptions() {
        let curves: [UIViewAnimationCurve] = [.EaseInOut, .EaseIn, .EaseOut, .Linear]

        let options = curves.map { c in
            KeyboardInfo.fromNotificationUserInfo([UIKeyboardAnimationCurveUserInfoKey: c.rawValue], state: .WillShow).animationOptions
        }
        XCTAssertEqual(options, [.CurveEaseInOut, .CurveEaseIn, .CurveEaseOut, .CurveLinear])
    }

    func testAnimationCurveDefaultValue() {
        // TODO: investigate this problem.
        // let curve = KeyboardInfo.fromNotificationUserInfo([UIKeyboardAnimationCurveUserInfoKey: 9], state: .WillShow).animationCurve
        // XCTAssertEqual(curve, UIViewAnimationCurve.EaseInOut)
    }
}
