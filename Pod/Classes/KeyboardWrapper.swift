
import UIKit

/// Implement the method of this protocol to respond to `UIKeyboard` notifications.
public protocol KeyboardWrapperDelegate: class {

    /// Called when `KeyboardWrapper` will receive `UIKeyboard[WillShow|DidShow|WillHide|DidHide]Notification`.
    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo)
}

/// Responsible for observing `UIKeyboard` notifications and calling `delegate` to notify about changes.
open class KeyboardWrapper {

    public let observableKeyboardStates: [KeyboardState]

    /// The delegate for keyboard notifications.
    open weak var delegate: KeyboardWrapperDelegate?

    /// Creates a new instance of `KeyboardWrapper` and adds itself as observer for `UIKeyboard` notifications.
    public init(observableKeyboardStates: [KeyboardState]) {
        self.observableKeyboardStates = observableKeyboardStates
        let center = NotificationCenter.default
        for state in observableKeyboardStates {
            center.addObserver(self, selector: #selector(keyboardNotification(_:)), name: state.notificationName, object: nil)
        }
    }

    /// Creates a new instance of `KeyboardWrapper`, adds itself as observer for `UIKeyboard` notifications and
    /// sets `delegate`.
    public convenience init(delegate: KeyboardWrapperDelegate, observableKeyboardStates: [KeyboardState]) {
        self.init(observableKeyboardStates: observableKeyboardStates)
        self.delegate = delegate
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardNotification(_ notification: Notification) {
        if let state = KeyboardState(notificationName: notification.name) {
            let info = KeyboardInfo(info: notification.userInfo, state: state)
            delegate?.keyboardWrapper(self, didChangeKeyboardInfo: info)
        }
    }
}

/// Represents the keyboard state.
public enum KeyboardState {

    /// Denotes hidden state of the keyboard.
    /// Corresponds to `UIKeyboardDidHideNotification`.
    case hidden

    /// Denotes state when the keyboard about to show.
    /// Corresponds to `UIKeyboardWillShowNotification`.
    case willShow

    /// Denotes visible state of the keyboard.
    /// Corresponds to `UIKeyboardDidShowNotification`.
    case visible

    /// Denotes state when the keyboard about to hide.
    /// Corresponds to `UIKeyboardWillHideNotification`.
    case willHide

    /// Denotes state when the keyboard about to change its frame.
    /// Corresponds to `UIKeyboardWillChangeFrameNotification`.
    case willChangeFrame

    /// Denotes state when the keyboard changed its frame.
    /// Corresponds to `UIKeyboardDidChangeFrameNotification`.
    case didChangeFrame

    /// A name of a notification that corresponds to this keyboard state.
    var notificationName: NSNotification.Name {
        switch self {
        case .hidden: return .UIKeyboardDidHide
        case .willShow: return .UIKeyboardWillShow
        case .visible: return .UIKeyboardDidShow
        case .willHide: return .UIKeyboardWillHide
        case .willChangeFrame: return .UIKeyboardWillChangeFrame
        case .didChangeFrame: return .UIKeyboardDidChangeFrame
        }
    }

    /// Creates the keyboard state from a notification name.
    init?(notificationName: Notification.Name) {
        switch notificationName {
        case .UIKeyboardDidHide : self = .hidden
        case .UIKeyboardWillShow: self = .willShow
        case .UIKeyboardDidShow: self = .visible
        case .UIKeyboardWillHide: self = .willHide
        case .UIKeyboardWillChangeFrame: self = .willChangeFrame
        case .UIKeyboardDidChangeFrame: self = .didChangeFrame
        default:
            return nil
        }
    }
}

/// Represents info about keyboard extracted from `NSNotification`.
public struct KeyboardInfo {

    /// The state of the keyboard.
    public let state: KeyboardState

    /// The start frame of the keyboard in screen coordinates.
    /// Corresponds to `UIKeyboardFrameBeginUserInfoKey`.
    public let beginFrame: CGRect

    /// The end frame of the keyboard in screen coordinates.
    /// Corresponds to `UIKeyboardFrameEndUserInfoKey`.
    public let endFrame: CGRect

    /// Defines how the keyboard will be animated onto or off the screen.
    /// Corresponds to `UIKeyboardAnimationCurveUserInfoKey`.
    public let animationCurve: UIViewAnimationCurve

    /// The duration of the animation in seconds.
    /// Corresponds to `UIKeyboardAnimationDurationUserInfoKey`.
    public let animationDuration: TimeInterval

    /// Options for animating constructed from `animationCurve` property.
    public var animationOptions: UIViewAnimationOptions {
        switch animationCurve {
        case .easeInOut: return UIViewAnimationOptions.curveEaseInOut
        case .easeIn: return UIViewAnimationOptions.curveEaseIn
        case .easeOut: return UIViewAnimationOptions.curveEaseOut
        case .linear: return UIViewAnimationOptions.curveLinear
        }
    }
}

public extension KeyboardInfo {
    /// Creates instance of `KeyboardInfo` using `userInfo` from `NSNotification` object and a keyboard state.
    /// If there is no info or `info` doesn't contain appropriate key-value pair uses default values.
    init(info: [AnyHashable: Any]?, state: KeyboardState) {
        self.state = state
        self.beginFrame = (info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        self.endFrame = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        self.animationCurve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .easeInOut
        self.animationDuration = TimeInterval(info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
    }
}
