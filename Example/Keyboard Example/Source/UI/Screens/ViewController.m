//
//  ViewController.m
//  Keyboard Example
//
//  Created by Merrick Sapsford on 19/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MSSKeyboardManagerDelegate>

@property (nonatomic, strong) MSSKeyboardManager *keyboardManager;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardManager = [MSSKeyboardManager keyboardManagerForResponder:self];
    [self.view becomeKeyboardDismissalResponder];
    
    [self.textField becomeFirstResponder];
}

#pragma mark - MSSKeyboardManagerDelegate

- (void)keyboardManager:(MSSKeyboardManager *)delegate willShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update {
    
}

- (void)keyboardManager:(MSSKeyboardManager *)delegate didShowKeyboardWithUpdate:(MSSKeyboardUpdate *)update {
    
}

- (void)keyboardManager:(MSSKeyboardManager *)delegate willHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update {
    
}

- (void)keyboardManager:(MSSKeyboardManager *)delegate didHideKeyboardWithUpdate:(MSSKeyboardUpdate *)update {
    
}

@end
