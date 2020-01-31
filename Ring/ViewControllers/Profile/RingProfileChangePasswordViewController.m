//
//  RingProfileChangePasswordViewController.m
//  Ring
//
//  Created by Medpats on 5/15/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingProfileChangePasswordViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "UIViewController+HandleKeyboard.h"

@interface RingProfileChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paddingBottomButton;
@property (strong, nonatomic) RingUser *user;
@end

@implementation RingProfileChangePasswordViewController
- (RingUser *)user
{
  if (!_user) {
    _user = [RingUser currentCacheUser];
  }
  return _user;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateUIs];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unregisterForKeyboardNotifications];
}

- (void)decorateUIs
{
  [self.oldPasswordText decorateEclipseWithRadius:3];
  [self.oldPasswordText decorateBorder:1 andColor:[UIColor lightGrayColor]];
  self.oldPasswordText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.oldPasswordText.leftViewMode = UITextFieldViewModeAlways;
  
  [self.currentPasswordText decorateEclipseWithRadius:3];
  [self.currentPasswordText decorateBorder:1 andColor:[UIColor lightGrayColor]];
  self.currentPasswordText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.currentPasswordText.leftViewMode = UITextFieldViewModeAlways;
  
  self.saveButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.saveButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
  self.saveButton.backgroundColor = [UIColor ringOrangeColor];
}

- (IBAction)confirmPasswordPressed:(id)sender {
  NSString *oldPass = self.oldPasswordText.text;
  NSString *newPass = self.currentPasswordText.text;
  if (!oldPass || !newPass || [oldPass isEmpty] || [newPass isEmpty]) {
    [UIViewController showMessage:@"Please enter both your current and new password." withTitle:@"Form data invalid"];
  }
  [RingAuthUser changePasswordWithCurrentPassword:oldPass newPassWord:newPass success:^{
    [self.navigationController popViewControllerAnimated:YES];
  }];
}

#pragma mark --KEYBOARD Delegate
- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  self.paddingBottomButton.constant += keyBoardHeight;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  self.paddingBottomButton.constant -= keyBoardHeight;
}
@end
