//
//  ViewController.swift
//  KeyboardWrapper
//
//  Created by Aleksey Kuznetsov on 10/11/2015.
//  Copyright (c) 2015 Aleksey Kuznetsov. All rights reserved.
//

import UIKit
import KeyboardWrapper

class ViewController: UIViewController {

    @IBOutlet private var bottomConstraint: NSLayoutConstraint!

    private var keyboardWrapper: KeyboardWrapper?

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardWrapper = KeyboardWrapper(delegate: self, observableKeyboardStates: [.willShow, .willHide])
    }

    @IBAction func tapGestureRecognizerAction(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ViewController: KeyboardWrapperDelegate {
    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {

        if info.state == .willShow || info.state == .visible {
            bottomConstraint.constant = info.endFrame.size.height
        } else {
            bottomConstraint.constant = 0.0
        }

        view.layoutIfNeeded()
    }
}

