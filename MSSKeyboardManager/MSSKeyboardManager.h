//
//  MSSKeyboardManager.h
//
//  Created by Merrick Sapsford on 07/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MSSKeyboardDismiss.h"

@class MSSKeyboardManager;

NS_ASSUME_NONNULL_BEGIN
@interface MSSKeyboardUpdate : NSObject

/**
 The frame of the keyboard at the beginning of the update.
 */
@property (nonatomic, assign, readonly) CGRect beginFrame;
/**
 The frame of the keyboard at the end of the update.
 */
@property (nonatomic, assign, readonly) CGRect endFrame;

/**
 The duration of the update animation.
 */
@property (nonatomic, assign, readonly) CGFloat animationDuration;
/**
 The update animation curve.
 */
@property (nonatomic, assign, readonly) UIViewAnimationCurve animationCurve;

/**
 Whether the update was summoned by the local app in split view.
 */
@property (nonatomic, assign, readonly) BOOL isLocal;

/**
 Whether the keyboard will be visible due to the update.
 */
@property (nonatomic, assign, readonly) BOOL keyboardVisible;
/**
 Whether the keyboard is docked during the update (iPad only)
 */
@property (nonatomic, assign, readonly) BOOL keyboardDocked;

+ (instancetype)updateWithDictionary:(NSDictionary *)updateDictionary;

@end

@protocol MSSKeyboardManagerDelegate <NSObject>
@optional

/**
 The keyboard will show.
 
 @param manager
 The keyboard manager.
 
 @param update
 The keyboard update
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager willShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update;
/**
 The keyboard did show.
 
 @param manager
 The keyboard manager.
 
 @param update
 The keyboard update
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager didShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update;
/**
 The keyboard will hide.
 
 @param manager
 The keyboard manager.
 
 @param update
 The keyboard update
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager willHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update;
/**
 The keyboard did hide.
 
 @param manager
 The keyboard manager.
 
 @param update
 The keyboard update
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager didHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update;
/**
 The keyboard will update from its current frame.
 
 @param manager
 The keyboard manager.
 
 @param frame
 The keyboard current frame.
 
 @param docked
 Whether the keyboard is docked.
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager keyboardWillUpdateFromFrame:(CGRect)frame isDocked:(BOOL)docked;
/**
 The keyboard did update to a new frame.
 
 @param manager
 The keyboard manager.
 
 @param frame
 The new keyboard frame.
 
 @param docked
 Whether the keyboard is docked.
 */
- (void)keyboardManager:(MSSKeyboardManager *)manager keyboardDidUpdateToFrame:(CGRect)frame isDocked:(BOOL)docked;

@end

@interface MSSKeyboardManager : NSObject

/**
 The object that responds to keyboard updates.
 */
@property (nonatomic, weak, readonly) id<MSSKeyboardManagerDelegate> responder;

/**
 Whether the keyboard manager is currently ignoring keyboard updates.
 */
@property (nonatomic, assign, readonly, getter=isIgnoringUpdates) BOOL ignoringUpdates;

+ (instancetype)keyboardManagerForResponder:(id<MSSKeyboardManagerDelegate>)responder;

/**
 Start ignoring any keyboard updates and stop updating responder.
 */
- (void)startIgnoringUpdates;
/**
 Resume listening to keyboard updates and updating responder.
 */
- (void)stopIgnoringUpdates;

@end
NS_ASSUME_NONNULL_END
