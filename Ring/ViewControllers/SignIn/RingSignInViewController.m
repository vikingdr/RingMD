//
//  TourSignInViewController.m
//  TourNative
//
//  Created by Medpats on 4/1/2557 BE.
//  Copyright (c) 2557 TourNative. All rights reserved.
//

#import "RingSignInViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#define FORGOT_PASS_ID @"forgot_pass"

@interface RingSignInViewController ()<UITextFieldDelegate, NavigationBarOptions>
{
  UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end

@implementation RingSignInViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self decorateUIs];
  [self initGestures];
  
  ringDelegate.storyboard = self.storyboard;
  if(currentUser) {
    [[RingNavigationController sharedNavigationController] pushUserDefaultViewController:NO];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)initGestures
{
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
  [self.view addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
  [activeField resignFirstResponder];
}

- (void)decorateUIs {
  [self.userNameText decorateEclipseWithRadius:3];
  [self.passwordText decorateEclipseWithRadius:3];
  [self.signInButton decorateEclipseWithRadius:3];
  [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.signInButton.backgroundColor = [UIColor ringMainColor];
  self.signInButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  
  for (UITextField *textField in @[_passwordText, _userNameText]) {
    textField.textColor = [UIColor blackColor];
    [textField decorateEclipseWithRadius:3];
    [textField decorateBorder:1 andColor:[UIColor lightGrayColor]];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont ringFontOfSize:14];
  }
  
  [self.signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  self.signUpButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}

- (IBAction)signInButtonPressed:(id)sender {
  [RingNetworkHelper logout];
  [RingAuthUser loginWithEmail:[self.userNameText text] password:[self.passwordText text] andSuccess:^{
    [[RingNavigationController sharedNavigationController] pushUserDefaultViewController:YES];
  }];
}

- (IBAction)forgotPasswordPressed:(id)sender {
  [activeField resignFirstResponder];
  UIAlertView *forgotPassword = [[UIAlertView alloc] initWithTitle:@"Forgot password" message:@"We will send you your account information" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
  [forgotPassword setAlertViewStyle:UIAlertViewStylePlainTextInput];
  UITextField *textField = [forgotPassword textFieldAtIndex:0];
  textField.placeholder = @"Email";
  textField.keyboardType = UIKeyboardTypeEmailAddress;
  textField.accessibilityIdentifier = FORGOT_PASS_ID;
  [forgotPassword show];
}

#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (![textField.text validateEmail]) {
      [UIViewController showMessage:@"Please enter your email address." withTitle:@"Form data invalid"];
      return;
    }
    [RingAuthUser forgotPasswordWithEmail:textField.text success:^{
      [UIViewController showMessage:@"We sent you an email. Please check your inbox (or spam folder if that fails)." withTitle:@"Email confirmation"];
    }];
  }
}

#pragma mark --UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.passwordText) {
    [self signInButtonPressed:nil];
  } else {
    [self.passwordText becomeFirstResponder];
  }
  return YES;
}

- (BOOL)shouldShowNavigationBar
{
  return NO;
}
@end
