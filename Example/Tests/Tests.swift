import UIKit
import XCTest
import KeyboardWrapper

class Tests: XCTestCase {

    let keyboardWrapperDelegate = Delegate()
    var keyboardWrapper: KeyboardWrapper?

    override func setUp() {
        super.setUp()
        keyboardWrapper = KeyboardWrapper(delegate: keyboardWrapperDelegate)
    }

    func testKeyboardStates() {
        let notificationNames = [
            UIKeyboardWillShowNotification,
            UIKeyboardDidShowNotification,
            UIKeyboardWillHideNotification,
            UIKeyboardDidHideNotification
        ]

        for name in notificationNames {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
        }

        XCTAssertEqual(keyboardWrapperDelegate.states, [.WillShow, .Visible, .WillHide, .Hidden])
    }
    
}

class Delegate: KeyboardWrapperDelegate {

    var states = [KeyboardState]()

    func keyboardWrapper(wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {
        states.append(info.state)
    }
}
