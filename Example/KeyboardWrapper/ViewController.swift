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

    @IBOutlet fileprivate var bottomConstraint: NSLayoutConstraint!

    fileprivate var keyboardWrapper: KeyboardWrapper?

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardWrapper = KeyboardWrapper(delegate: self)
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

        UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

