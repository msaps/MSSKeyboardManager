//
//  MSSKeyboardManager.m
//
//  Created by Merrick Sapsford on 07/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSKeyboardManager.h"

@implementation MSSKeyboardUpdate

+ (instancetype)updateWithDictionary:(NSDictionary *)updateDictionary {
    return [[[self class]alloc]initWithDictionary:updateDictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _beginFrame = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
        _endFrame = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        _animationDuration = [[dictionary objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
        _animationCurve = [[dictionary objectForKey:UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
        _isLocal = [[dictionary objectForKey:UIKeyboardIsLocalUserInfoKey]boolValue];
        
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat screenHeight = UIInterfaceOrientationIsPortrait(currentOrientation) ? screenSize.height : screenSize.width;
        
        CGRect frame = CGRectEqualToRect(self.endFrame, CGRectZero) ? self.beginFrame : self.endFrame; // default to end frame
        CGFloat dockedYOffset = screenHeight - frame.size.height;
        CGFloat actualYOffset = CGRectGetMinY(frame);
        
        if (actualYOffset != screenHeight && (CGRectGetMaxY(frame) <= screenHeight)) { // if keyboard is visible
            _keyboardVisible = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && (actualYOffset < dockedYOffset)) { // check if keyboard is docked
                _keyboardDocked = (dockedYOffset == actualYOffset);
            } else {
                _keyboardDocked = YES; // always docked on iPhone
            }
        } else { // keyboard not visible
            _keyboardVisible = NO;
        }
    }
    return self;
}

@end

@implementation MSSKeyboardManager

#pragma mark - Init

+ (instancetype)keyboardManagerForResponder:(id<MSSKeyboardManagerDelegate>)responder {
    return [[[self class]alloc]initWithResponder:responder];
}

- (instancetype)initWithResponder:(id<MSSKeyboardManagerDelegate>)responder {
    if (self = [super init]) {
        _responder = responder;
        [self registerNotifications];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)dealloc {
    [self unregisterNotifications];
}

#pragma mark - Notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardManager:willShowKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardManager:self willShowKeyboardWithUpdate:update];
    }
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardManager:didShowKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardManager:self didShowKeyboardWithUpdate:update];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardManager:willHideKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardManager:self willHideKeyboardWithUpdate:update];
    }
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardManager:didHideKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardManager:self didHideKeyboardWithUpdate:update];
    }
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
    if ((update.keyboardVisible && !CGRectEqualToRect(update.beginFrame, CGRectZero)) &&
        [self.responder respondsToSelector:@selector(keyboardManager:keyboardWillUpdateFromFrame:isDocked:)]) {
        
        [self.responder keyboardManager:self keyboardWillUpdateFromFrame:update.beginFrame isDocked:update.keyboardDocked];
    }
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification {
    MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
    if ((update.keyboardVisible && !CGRectEqualToRect(update.endFrame, CGRectZero)) &&
        [self.responder respondsToSelector:@selector(keyboardManager:keyboardDidUpdateToFrame:isDocked:)]) {
        
        [self.responder keyboardManager:self keyboardDidUpdateToFrame:update.endFrame isDocked:update.keyboardDocked];
    }
}

#pragma mark - Public

- (void)startIgnoringUpdates {
    if (!_ignoringUpdates) {
        _ignoringUpdates = YES;
        [self unregisterNotifications];
    }
}

- (void)stopIgnoringUpdates {
    if (_ignoringUpdates) {
        _ignoringUpdates = NO;
        [self registerNotifications];
    }
}

#pragma mark - Internal

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShowNotification:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidShowNotification:)
                                                name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHideNotification:)
                                                name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidHideNotification:)
                                                name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillChangeFrameNotification:)
                                                name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidChangeFrameNotification:)
                                                name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
