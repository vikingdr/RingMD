//
//  TourSignUpView.m
//  TourNative
//
//  Created by Medpats on 4/4/2557 BE.
//  Copyright (c) 2557 TourNative. All rights reserved.
//

#import "RingSignUpViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingCountryCodeViewController.h"

@interface RingSignUpViewController()<UITextFieldDelegate,RingCountryCodeViewControllerDelegate, NavigationBarOptions>
{
  UITextField *activeField;
  RingCountryCodeViewController *phoneCodeViewController;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeText;
@property (weak, nonatomic) IBOutlet UITextField *phoneRawNumberText;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeight;

@property (strong, nonatomic) RingAuthUser *user;

@end

@implementation RingSignUpViewController

- (RingAuthUser *)user {
  if (!_user) {
    _user = [RingAuthUser createEmptyUser];
  }
  return _user;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self initGestures];
  [self decorateUIs];
  [self initPhoneCodeView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.containerHeight.constant = self.view.frame.size.height;
  [[Locator sharedLocator] obtainLocation:^(NSString *country) { }];
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
  [self.signUpButton decorateEclipseWithRadius:3];
  [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.signUpButton.backgroundColor = [UIColor ringMainColor];
  self.signUpButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  
  for (UITextField *textField in @[_firstNameText,_passwordText, _phoneCodeText, _phoneRawNumberText, _emailText]) {
    textField.textColor = [UIColor blackColor];
    [textField decorateEclipseWithRadius:3];
    [textField decorateBorder:1 andColor:[UIColor lightGrayColor]];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  }
  
  [self.signInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  self.signInButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}

- (void)initPhoneCodeView
{
  phoneCodeViewController = [[RingCountryCodeViewController alloc] initWithNibName:@"RingCountryCodeViewController" bundle:nil];
  phoneCodeViewController.delegate = self;
  self.phoneCodeText.inputView = phoneCodeViewController.view;
}

- (IBAction)signUpPressed:(id)sender {
  self.user.email = self.emailText.text;
  self.user.name = self.firstNameText.text;
  self.user.password = self.passwordText.text;
  self.user.phoneCode = self.phoneCodeText.text;
  self.user.phoneRawNumber = self.phoneRawNumberText.text;
  self.user.isDoctor = @(NO);
  if (![self.user validateFields]) {
    return;
  }
  [self.user signUpforPatientWithSuccess:^{
    [[RingNavigationController sharedNavigationController] pushUserDefaultViewController:YES];
  }];
}

- (IBAction)showSignInPressed:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --RingCountryCodeViewController
- (NSString *)selectedCountryCode
{
  return self.phoneCodeText.text;
}

- (void)didSelectCountryCode:(NSString *)code
{
  self.phoneCodeText.text = code;
}

#pragma mark --UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.phoneRawNumberText) {
    [self signUpPressed:nil];
  } else if (textField == self.emailText){
    [self.firstNameText becomeFirstResponder];
  } else if (textField == self.firstNameText) {
    [self.passwordText becomeFirstResponder];
  } else if (textField == self.passwordText) {
    [self.phoneCodeText becomeFirstResponder];
  } else if (textField == self.phoneCodeText) {
    [self.phoneRawNumberText becomeFirstResponder];
  }
  return YES;
}

- (BOOL)shouldShowNavigationBar
{
  return NO;
}
@end
