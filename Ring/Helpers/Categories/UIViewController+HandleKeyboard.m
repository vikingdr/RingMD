//
//  UIViewController+HandleKeyboard.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved..
//

#import "UIViewController+HandleKeyboard.h"

#import "Ring-Essentials.h"

@interface UIViewController()
@property (strong, nonatomic) UIScrollView *scrollViewContainer;
@property (strong, nonatomic) UIView *activeField;
@end

@implementation UIViewController (HandleKeyboard)
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)unregisterForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)scrollToVisible
{
  [self.scrollViewContainer scrollRectToVisible:self.activeField.frame animated:YES];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 
  CGFloat keyBoardHeight = kbSize.height;
  if ([RingUtility isLandscape]) {
    keyBoardHeight = kbSize.width;
  }
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0);
  self.scrollViewContainer.contentInset = contentInsets;
  self.scrollViewContainer.scrollIndicatorInsets = contentInsets;
  [self scrollToVisible];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollViewContainer.contentInset = contentInsets;
  self.scrollViewContainer.scrollIndicatorInsets = contentInsets;
}
@end
