//
//  UIViewController+HandleKeyboard.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HandleKeyboard)
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
@end
