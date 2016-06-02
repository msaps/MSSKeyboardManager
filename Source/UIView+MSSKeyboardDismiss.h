//
//  UIView+MSSKeyboardDismiss.h
//
//  Created by Merrick Sapsford on 04/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MSSKeyboardDismissCompetion)(BOOL resigned);

IB_DESIGNABLE
@interface UIView (MSSKeyboardDismiss) <UIGestureRecognizerDelegate>

/**
 Whether the view can dismiss keyboard on tap.
 */
@property (nonatomic, assign) IBInspectable BOOL canDismissKeyboard;

/**
 Become the responder for dismissing the keyboard on tap.
 */
- (void)becomeKeyboardDismissalResponder;
/**
 Resign the active first responder with completion.
 
 @param completion
 The completion block.
 */
- (void)resignFirstResponderWithCompletion:(MSSKeyboardDismissCompetion)completion;

@end
