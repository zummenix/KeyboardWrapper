# KeyboardWrapper
A safe wrapper for UIKeyboard notifications written in Swift.

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
    func keyboardWrapper(wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {

        if info.state == .WillShow || info.state == .Visible {
            bottomConstraint.constant = info.endFrame.size.height
        } else {
            bottomConstraint.constant = 0.0
        }

        UIView.animateWithDuration(info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
```

## Installation

KeyboardWrapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyboardWrapper"
```

## License

KeyboardWrapper is available under the MIT license. See the LICENSE file for more info.
