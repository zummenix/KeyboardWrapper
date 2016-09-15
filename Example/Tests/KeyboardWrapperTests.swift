import UIKit
import XCTest
import KeyboardWrapper

class KeyboardWrapperTests: XCTestCase {

    let keyboardWrapperDelegate = Delegate()
    var keyboardWrapper: KeyboardWrapper?

    override func setUp() {
        super.setUp()
        keyboardWrapper = KeyboardWrapper(delegate: keyboardWrapperDelegate)
    }

    override func tearDown() {
        super.tearDown()
        keyboardWrapper = nil
    }

    func testKeyboardStates() {
        let notificationNames = [
            NSNotification.Name.UIKeyboardWillShow,
            NSNotification.Name.UIKeyboardDidShow,
            NSNotification.Name.UIKeyboardWillHide,
            NSNotification.Name.UIKeyboardDidHide
        ]

        for name in notificationNames {
            NotificationCenter.default.post(name: name, object: nil)
        }

        XCTAssertEqual(keyboardWrapperDelegate.states, [.willShow, .visible, .willHide, .hidden])
    }
    
}

class Delegate: KeyboardWrapperDelegate {

    var states = [KeyboardState]()

    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {
        states.append(info.state)
    }
}
