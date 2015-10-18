
import UIKit

public protocol KeyboardWrapperDelegate: class {
    func keyboardWrapper(wrapper: KeyboardWrapper, didChangeWithKeyboardInfo info: KeyboardInfo)
}

/// Responsible for observing `UIKeyboard` notifications and calling delegate
/// to notify about changes.
public class KeyboardWrapper {

    /// The delegate for keyboard notifications.
    public weak var delegate: KeyboardWrapperDelegate?

    public init() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardDidShowNotification:", name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: "keyboardDidHideNotification:", name: UIKeyboardDidHideNotification, object: nil)
    }

    public convenience init(delegate: KeyboardWrapperDelegate) {
        self.init()
        self.delegate = delegate
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private dynamic func keyboardWillShowNotification(notification: NSNotification) {
        let info = KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .WillShow)
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: info)
    }

    private dynamic func keyboardDidShowNotification(notification: NSNotification) {
        let info = KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .Visible)
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: info)
    }

    private dynamic func keyboardWillHideNotification(notification: NSNotification) {
        let info = KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .WillHide)
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: info)
    }

    private dynamic func keyboardDidHideNotification(notification: NSNotification) {
        let info = KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .Hidden)
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: info)
    }
}

/// Represents keyboard state.
public enum KeyboardState {

    /// Denotes hidden state of keyboard.
    case Hidden

    /// Denotes state when keyboard about to show.
    case WillShow

    /// Denotes visible state of keyboard.
    case Visible

    /// Denotes state when keyboard about to hide.
    case WillHide
}

/// Represents info about keyboard extracted from `NSNotification`.
public struct KeyboardInfo {

    /// The state of keyboard.
    public let state: KeyboardState

    /// The start frame of the keyboard in screen coordinates.
    public let beginFrame: CGRect

    /// The end frame of the keyboard in screen coordinates.
    public let endFrame: CGRect

    /// Defines how the keyboard will be animated onto or off the screen.
    public let animationCurve: UIViewAnimationCurve

    /// The duration of the animation in seconds.
    public let animationDuration: NSTimeInterval

    /// Options for animating constructed from `animationCurve`.
    public var animationOptions: UIViewAnimationOptions {
        switch animationCurve {
        case .EaseInOut: return UIViewAnimationOptions.CurveEaseInOut
        case .EaseIn: return UIViewAnimationOptions.CurveEaseIn
        case .EaseOut: return UIViewAnimationOptions.CurveEaseOut
        case .Linear: return UIViewAnimationOptions.CurveLinear
        }
    }

    /// Creates instance of `KeyboardInfo` using `userInfo` from `NSNotification` object and keyboard state.
    /// If there is no info or `info` doesn't contain appropriate key-value pair uses default values.
    public static func fromNotificationUserInfo(info: [NSObject : AnyObject]?, state: KeyboardState) -> KeyboardInfo {
        var beginFrame = CGRectZero
        info?[UIKeyboardFrameBeginUserInfoKey]?.getValue(&beginFrame)

        var endFrame = CGRectZero
        info?[UIKeyboardFrameEndUserInfoKey]?.getValue(&endFrame)

        let curve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .EaseInOut
        let duration = NSTimeInterval(info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
        return KeyboardInfo(state: state, beginFrame: beginFrame, endFrame: endFrame, animationCurve: curve, animationDuration: duration)
    }
}
