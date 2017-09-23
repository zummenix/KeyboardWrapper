# KeyboardWrapper
[![Build Status](https://travis-ci.org/zummenix/KeyboardWrapper.svg?branch=master)](https://travis-ci.org/zummenix/KeyboardWrapper)
[![Cocoapod](https://img.shields.io/cocoapods/v/KeyboardWrapper.svg)](https://cocoapods.org/pods/KeyboardWrapper)

A safe wrapper for UIKeyboard notifications written in Swift.

<img src="https://raw.github.com/zummenix/KeyboardWrapper/master/demo.gif" alt="Demo" width="372" height="662"/>

## Usage

- Import module
```Swift
import KeyboardWrapper
```

- Create `KeyboardWrapper` instance
```Swift
keyboardWrapper = KeyboardWrapper(delegate: self)
```

- Implement `KeyboardWrapperDelegate`
```Swift
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
```

## Requirements

- **iOS 8.0** or higher
- **Xcode 9.0 (swift 4.0)** or higher

For older versions of xcode and swift please use `3.0.1` version of the lib.

## Changes

Take a look at [change log](CHANGELOG.md).

## Installation

### CocoaPods

KeyboardWrapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KeyboardWrapper', '~> 4.0'
```

### Manual

Just drop the `KeyboardWrapper.swift` file into your project. That's it!

## License

KeyboardWrapper is available under the MIT license. See the LICENSE file for more info.
