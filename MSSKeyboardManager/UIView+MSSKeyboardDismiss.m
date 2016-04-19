//
//  UIView+MSSKeyboardDismiss.m
//
//  Created by Merrick Sapsford on 04/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "UIView+MSSKeyboardDismiss.h"
#import <objc/runtime.h>

@implementation UIView (MSSKeyboardDismiss)

static id _currentFirstResponder;
static char TAP_GESTURE_RECOGNIZER;
static CGFloat _keyboardAnimationDuration;

#pragma mark - Lifecycle

- (BOOL)becomeFirstResponder {
    _currentFirstResponder = self;
    
    // if keyboard anim length is unknown attempt to get it
    if (_keyboardAnimationDuration == 0.0f) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(keyboardWillShow:)
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    return [super resignFirstResponder];
}

#pragma mark - Gesture Recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    UIView *targetView = touch.view;
    
    BOOL shouldRespond = YES;
    if ([targetView respondsToSelector:@selector(canDismissKeyboard)]) { // only respond if view allows
        shouldRespond = [targetView canDismissKeyboard];
    }
    
    // dont respond if view is the first responder
    if (targetView.isFirstResponder || !shouldRespond || !self.canDismissKeyboard) {
        return NO;
    }
    return YES;
}

#pragma mark - Public

- (void)becomeKeyboardDismissalResponder {
    if (!self.tapGestureRecognizer) {
        [self addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)setCanDismissKeyboard:(BOOL)canDismissKeyboard {
    objc_setAssociatedObject(self,
                             @selector(canDismissKeyboard),
                             @(canDismissKeyboard),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canDismissKeyboard {
    NSNumber *value = objc_getAssociatedObject(self, @selector(canDismissKeyboard));
    if (!value) {
        return YES;
    }
    return [value boolValue];
}

- (void)resignFirstResponderWithCompletion:(void (^)(BOOL))completion {
    BOOL resigned = [self resignFirstResponder];
    
    if (completion) {
        if (resigned) {
            CGFloat duration = _keyboardAnimationDuration > 0.0f ? _keyboardAnimationDuration : 0.25f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC),
                           dispatch_get_main_queue(), ^{
                               completion(resigned);
                           });
        } else {
            completion(resigned);
        }
    }
}

#pragma mark - Internal

- (void)resignCurrentFirstResponder {
    [_currentFirstResponder resignFirstResponder];
}

- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentFirstResponder)];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [self setTapGestureRecognizer:tapRecognizer];
    return tapRecognizer;
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    objc_setAssociatedObject(self, &TAP_GESTURE_RECOGNIZER, tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    return objc_getAssociatedObject(self, &TAP_GESTURE_RECOGNIZER);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    _keyboardAnimationDuration = animationDuration;
}


@end
