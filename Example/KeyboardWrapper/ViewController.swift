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
        keyboardWrapper = KeyboardWrapper(delegate: self)
    }

    @IBAction func tapGestureRecognizerAction(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ViewController: KeyboardWrapperDelegate {
    func keyboardWrapper(wrapper: KeyboardWrapper, didChangeWithKeyboardInfo info: KeyboardInfo) {
        bottomConstraint.constant = (wrapper.state == .WillShow || wrapper.state == .Visible) ? info.endFrame.size.height : 0.0
        UIView.animateWithDuration(info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

