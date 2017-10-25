import UIKit
import XCTest
import KeyboardWrapper

class KeyboardWrapperTests: XCTestCase {

    let keyboardWrapperDelegate = Delegate()

    override func setUp() {
        super.setUp()
        keyboardWrapperDelegate.states = []
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAllKeyboardStates() {
        let allStates: [KeyboardState] = [.willShow, .visible, .willChangeFrame, .didChangeFrame, .willHide, .hidden]
        let keyboardWrapper = KeyboardWrapper(delegate: keyboardWrapperDelegate, observableKeyboardStates: allStates)
        XCTAssertEqual(keyboardWrapper.observableKeyboardStates, allStates)

        let notificationNames = [
            NSNotification.Name.UIKeyboardWillShow,
            NSNotification.Name.UIKeyboardDidShow,
            NSNotification.Name.UIKeyboardWillChangeFrame,
            NSNotification.Name.UIKeyboardDidChangeFrame,
            NSNotification.Name.UIKeyboardWillHide,
            NSNotification.Name.UIKeyboardDidHide
        ]

        for name in notificationNames {
            NotificationCenter.default.post(name: name, object: nil)
        }

        XCTAssertEqual(keyboardWrapperDelegate.states, [.willShow, .visible, .willChangeFrame, .didChangeFrame, .willHide, .hidden])
    }

    func testSomeKeyboardStates() {
        let someStates: [KeyboardState] = [.willChangeFrame, .willHide]
        let keyboardWrapper = KeyboardWrapper(delegate: keyboardWrapperDelegate, observableKeyboardStates: someStates)
        XCTAssertEqual(keyboardWrapper.observableKeyboardStates, someStates)

        let notificationNames = [
            NSNotification.Name.UIKeyboardWillShow,
            NSNotification.Name.UIKeyboardDidShow,
            NSNotification.Name.UIKeyboardWillChangeFrame,
            NSNotification.Name.UIKeyboardDidChangeFrame,
            NSNotification.Name.UIKeyboardWillHide,
            NSNotification.Name.UIKeyboardDidHide
        ]

        for name in notificationNames {
            NotificationCenter.default.post(name: name, object: nil)
        }

        XCTAssertEqual(keyboardWrapperDelegate.states, [.willChangeFrame, .willHide])
    }

    func testOrderOfSomeKeyboardStates() {
        let someStates: [KeyboardState] = [.willChangeFrame, .willHide]
        let keyboardWrapper = KeyboardWrapper(delegate: keyboardWrapperDelegate, observableKeyboardStates: someStates)
        XCTAssertEqual(keyboardWrapper.observableKeyboardStates, someStates)

        let notificationNames = [
            NSNotification.Name.UIKeyboardWillShow,
            NSNotification.Name.UIKeyboardDidShow,
            NSNotification.Name.UIKeyboardWillHide,
            NSNotification.Name.UIKeyboardWillChangeFrame,
        ]

        for name in notificationNames {
            NotificationCenter.default.post(name: name, object: nil)
        }

        XCTAssertEqual(keyboardWrapperDelegate.states, [.willHide, .willChangeFrame])
    }
}

class Delegate: KeyboardWrapperDelegate {

    var states = [KeyboardState]()

    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {
        states.append(info.state)
    }
}
