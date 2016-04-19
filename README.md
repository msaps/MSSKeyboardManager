# MSSKeyboardManager

MSSKeyboardManager is a utility class that provides enhanced delegation for keyboard updates, and a keyboard dismissal component for UIView.

## Installation
MSSTabbedPageViewController is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "MSSKeyboardManager"
    
## Usage
To run the example project, clone the repo. Use `pod install` in your project.

###Keyboard Manager
To use `MSSKeyboardManager`, initialise the object with a responder that implements `MSSKeyboardManagerDelegate` via `keyboardManagerForResponder:`

The following protocol methods are then available to the responder:

```
- (void)keyboardManager:(MSSKeyboardManager *)manager willShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update;

- (void)keyboardManager:(MSSKeyboardManager *)manager didShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update;

- (void)keyboardManager:(MSSKeyboardManager *)manager willHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update;

- (void)keyboardManager:(MSSKeyboardManager *)manager didHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update;

- (void)keyboardManager:(MSSKeyboardManager *)manager keyboardWillUpdateFromFrame:(CGRect)frame isDocked:(BOOL)docked;

- (void)keyboardManager:(MSSKeyboardManager *)manager keyboardDidUpdateToFrame:(CGRect)frame isDocked:(BOOL)docked;
```

The `MSSKeyboardUpdate` object contains all the releavent information for the active update:

- `beginFrame` - The frame of the keyboard at the beginning of the update.
- `endFrame` - The frame of the keyboard at the end of the update.
- `animationDuration` - The duration of the update animation.
- `animationCurve` - The update animation curve.
- `isLocal` - Whether the update was invoked by the local app (iOS 9+)
- `keyboardVisible` - Whether the keyboard will be visible as a result of the update.
- `keyboardDocked` - Whether the keyboard is docked during the update (iPad).

###Keyboard Dismisser
`UIView+MSSKeyboardDismiss` is a category on UIView that provides keyboard dismissal on tap.

To allow a UIView to dismiss the keyboard on tap, simply call `becomeKeyboardDismissalResponder` on the view. 

For example, in the context of a UIViewController:
```
[self.view becomeKeyboardDismissalResponder];
```

Subviews of the view can then opt out of allowing dismissal on tap with the `canDismissKeyboard` property (IBInspectable).

The category also provides `resignFirstResponderWithCompletion:` to allow the keyboard to be dismissed with a completion block.

## Requirements
Supports iOS 8 and above.

## Author
Merrick Sapsford

Mail: [merrick@sapsford.tech](mailto:merrick@sapsford.tech)