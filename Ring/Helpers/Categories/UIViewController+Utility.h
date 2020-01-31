//
//  UIViewController+Utility.h
//  Mingle
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility)
- (void)decorateWhitebackground;
- (void)decorateEditButton;
- (void)decoratePlusButton;
- (void)decorateCheckButton;
- (void)decorateMedicalHistoryButton;

- (UIImageView *)videoIcon;
- (UIImageView *)videoActiveIcon;
- (UIImageView *)callIcon;
- (UIImageView *)callActiveIcon;

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;

- (void)popViewControllerAnimated:(BOOL)animated;
- (void)dismissPopup:(id)sender;
- (void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion;
@end
