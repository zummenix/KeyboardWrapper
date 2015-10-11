
import UIKit

public protocol KeyboardWrapperDelegate: class {
    func keyboardWrapper(wrapper: KeyboardWrapper, didChangeWithKeyboardInfo info: KeyboardInfo)
}

public class KeyboardWrapper {

    public weak var delegate: KeyboardWrapperDelegate?

    private(set) public var state = KeyboardState.Hidden

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
        state = .WillShow
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: KeyboardInfo.fromNotificationUserInfo(notification.userInfo))
    }

    private dynamic func keyboardDidShowNotification(notification: NSNotification) {
        state = .Visible
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: KeyboardInfo.fromNotificationUserInfo(notification.userInfo))
    }

    private dynamic func keyboardWillHideNotification(notification: NSNotification) {
        state = .WillHide
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: KeyboardInfo.fromNotificationUserInfo(notification.userInfo))
    }

    private dynamic func keyboardDidHideNotification(notification: NSNotification) {
        state = .Hidden
        delegate?.keyboardWrapper(self, didChangeWithKeyboardInfo: KeyboardInfo.fromNotificationUserInfo(notification.userInfo))
    }
}

public enum KeyboardState {
    case Hidden, WillShow, Visible, WillHide
}

public struct KeyboardInfo {
    public let beginFrame: CGRect
    public let endFrame: CGRect
    public let animationCurve: UIViewAnimationCurve
    public let animationDuration: NSTimeInterval
    public var animationOptions: UIViewAnimationOptions {
        switch animationCurve {
        case .EaseInOut: return UIViewAnimationOptions.CurveEaseInOut
        case .EaseIn: return UIViewAnimationOptions.CurveEaseIn
        case .EaseOut: return UIViewAnimationOptions.CurveEaseOut
        case .Linear: return UIViewAnimationOptions.CurveLinear
        }
    }

    public static func fromNotificationUserInfo(info: [NSObject : AnyObject]?) -> KeyboardInfo {
        var beginFrame = CGRectZero
        info?[UIKeyboardFrameBeginUserInfoKey]?.getValue(&beginFrame)

        var endFrame = CGRectZero
        info?[UIKeyboardFrameEndUserInfoKey]?.getValue(&endFrame)

        let curve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .EaseInOut
        let duration = NSTimeInterval(info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
        return KeyboardInfo(beginFrame: beginFrame, endFrame: endFrame, animationCurve: curve, animationDuration: duration)
    }
}
