//
//  UIViewController+HandleKeyboard.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HandleKeyboard)
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
@end
