//
//  UIViewController+Utility.m
//  Mingle
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "UIViewController+Utility.h"

#import "Ring-Essentials.h"

#import "RingSearchViewController.h"

@interface UIViewController()
@end

@implementation UIViewController (Utility)
- (void)decorateWhitebackground
{
  self.view.backgroundColor = [UIColor ringWhiteColor];
}

- (void)decorateEditButton
{
  UIButton *button = [UIButton ringEditButton];
  [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
  UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  
  self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)decoratePlusButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 40, 40);
  [button setImage:[UIImage imageNamed:@"plus-white"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
  UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithCustomView:button];
  self.navigationItem.rightBarButtonItem = search;
}

- (void)decorateCheckButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 40, 40);
  [button setImage:[UIImage imageNamed:@"check-white"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
  UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithCustomView:button];
  self.navigationItem.rightBarButtonItem = search;
}

- (void)decorateMedicalHistoryButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 40, 40);
  [button setImage:[UIImage imageNamed:@"history-white"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(medicalHistoryAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
  UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithCustomView:button];
  self.navigationItem.rightBarButtonItem = search;
}

- (void)decorateInputSearch:(BOOL)hidden
{
  [self.navigationController.navigationBar setTranslucent:YES];
  if (hidden) {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
  } else {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
  }
}

- (void)checkAction:(UIButton *)sender
{
  
}

- (void)medicalHistoryAction:(UIButton *)sender
{

}

- (void)plusAction:(UIButton *)sender
{

}

- (void)editAction:(UIButton *)sender
{
  sender.selected = !sender.selected;
  [self setEditing:sender.selected];
}

- (UIImageView *)callActiveIcon
{
  UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 20, 20)];
  icon.image = [UIImage imageNamed:@"call-active"];
  return icon;
}

- (UIImageView *)videoActiveIcon
{
  UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 20, 20)];
  icon.image = [UIImage imageNamed:@"video-call-active"];
  return icon;
}

- (UIImageView *)callIcon
{
  UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 20, 20)];
  icon.image = [UIImage imageNamed:@"call-inactive"];
  return icon;
}

- (UIImageView *)videoIcon
{
  UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 20, 20)];
  icon.image = [UIImage imageNamed:@"video-call-inactive"];
  return icon;
}
  
- (void)initDoneButtonForKeyboard:(UITextField *)searchInput
{
  UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
  keyboardDoneButtonView.barStyle       = UIBarStyleBlack;
  keyboardDoneButtonView.translucent    = YES;
  keyboardDoneButtonView.tintColor  = nil;
  [keyboardDoneButtonView sizeToFit];
  
  UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:[RingUtility appDelegate] action:@selector(doneButtonPressed)];
  
  UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
  searchInput.inputAccessoryView = keyboardDoneButtonView;
}

- (void)doneButtonPressed
{

}

- (void)popViewControllerAnimated:(BOOL)animated
{
  [self.navigationController popViewControllerAnimated:animated];
}

- (void)dismissPopup:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title
{
  UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
  [messageAlert show];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
  UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
  [messageAlert show];
}

- (void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
  viewControllerToPresent.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPopup:)];
  
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
  
  [self.navigationController presentViewController:nav animated:animated completion:completion];
}
@end
