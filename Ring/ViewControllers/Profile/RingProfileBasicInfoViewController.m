//
//  RingProfileBasicInfoViewController.m
//  Ring
//
//  Created by Medpats on 5/15/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingProfileBasicInfoViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "UIViewController+HandleKeyboard.h"
#import "RingCountryCodeViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface RingProfileBasicInfoViewController ()<RingCountryCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UITextField *nameValueText;
@property (weak, nonatomic) IBOutlet UILabel *emailPasswordText;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberText;
@property (weak, nonatomic) IBOutlet RingTextField *countryCodeValueText;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneValueText;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UITextField *locationValueText;
@property (weak, nonatomic) IBOutlet UILabel *willKeepPrivateText;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneShow;
@property (weak, nonatomic) IBOutlet UIView *phoneEditingContainer;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property BOOL dirty;
@property (nonatomic) UIAlertController *changePasswordAlertController;

@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) UIView *activeField;

@property (strong, nonatomic) RingUser *user;
@end

@implementation RingProfileBasicInfoViewController

- (NSString *)countryCode
{
  if (!_countryCode) {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    _countryCode = [NSString stringWithFormat:@"+%@", [carrier mobileCountryCode]];
    if (self.user.phoneCode) {
      _countryCode = self.user.phoneCode;
    }
  }
  return _countryCode;
}

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
  self.title = @"Basic Information";
  [self initGestures];
  [self initCountryCodeWidget];
  
  if(UIAlertController.class == nil) {
    NSLog(@"iOS 7 detected. Will disable the password button.");
    self.changePasswordButton.hidden = YES;
  }
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

- (void)viewDidDisappear:(BOOL)animated
{
  [self saveChanges];
}

- (void)initGestures
{
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
  [self.view addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
  [self.activeField resignFirstResponder];
}

- (void)decorateUIs
{
  self.nameText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.emailPasswordText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.phoneNumberText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.locationText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.willKeepPrivateText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.willKeepPrivateText.textColor = [UIColor ringLightMainColor];
  
  self.nameValueText.text = self.user.name;
  self.locationValueText.text = self.user.location;
  
  [self.nameValueText decorateEclipseWithRadius:3];
  [self.nameValueText decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.nameValueText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.nameValueText.leftViewMode = UITextFieldViewModeAlways;
  
  [self.locationValueText decorateEclipseWithRadius:3];
  [self.locationValueText decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.locationValueText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.locationValueText.leftViewMode = UITextFieldViewModeAlways;
  
  [self.countryCodeValueText decorateEclipseWithRadius:3];
  [self.countryCodeValueText decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.countryCodeValueText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.countryCodeValueText.leftViewMode = UITextFieldViewModeAlways;
  
  [self.numberPhoneValueText decorateEclipseWithRadius:3];
  [self.numberPhoneValueText decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.numberPhoneValueText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.numberPhoneValueText.leftViewMode = UITextFieldViewModeAlways;
  
  self.numberPhoneShow.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.numberPhoneShow decorateEclipseWithRadius:3];
  [self.numberPhoneShow decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.numberPhoneShow.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.numberPhoneShow.leftViewMode = UITextFieldViewModeAlways;
  self.numberPhoneShow.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.numberPhoneShow.keyboardType = UIKeyboardTypeNumberPad;
  
  [self updatePhoneValues];
}

- (void)updatePhoneValues
{
  self.countryCodeValueText.text = self.user.phoneCode;
  self.numberPhoneValueText.text = self.user.phoneRawNumber;
}

- (void)saveChanges {
  if(self.dirty) {
    self.user.name = self.nameValueText.text;
    self.user.phoneCode = self.countryCode;
    self.user.phoneRawNumber = self.numberPhoneValueText.text;
    self.user.location = self.locationValueText.text;
    self.dirty = NO;
    
    [self.user updateProfile:^{
      [self updatePhoneValues];
    } withAvatarURL:nil];
  }
}

- (void)initCountryCodeWidget {
  RingCountryCodeViewController *controller = [[RingCountryCodeViewController alloc] initWithNibName:@"RingCountryCodeViewController" bundle:nil];
  controller.delegate = self;
  [self.countryCodeValueText setInputViewController:controller];
}

#pragma mark --RingCountryCodeViewController
- (void)didSelectCountryCode:(NSString *)code
{
  _countryCode = code;
  self.countryCodeValueText.text = code;
}

- (NSString *)selectedCountryCode
{
  return self.countryCodeValueText.text;
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField == self.nameValueText) {
    [self.countryCodeValueText becomeFirstResponder];
    return NO;
  } else if(textField == self.countryCodeValueText) {
    [self.numberPhoneValueText becomeFirstResponder];
    return NO;
  } else if(textField == self.numberPhoneValueText) {
    [self.locationValueText becomeFirstResponder];
    return NO;
  }
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if(!self.dirty) {
    NSLog(@"Marking view as dirty");
    self.dirty = YES;
  }
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.activeField = textField;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
  [textField resignFirstResponder];
  self.user.phoneCode = nil;
  self.user.phoneRawNumber = nil;
  [self updatePhoneValues];
  return YES;
}

- (void)initPasswordTextfield:(UITextField *)textField
{
  textField.secureTextEntry = YES;
  
  [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    BOOL enable = YES;
    for(UITextField *v in self.changePasswordAlertController.textFields) {
      enable = enable && ![v.text isEmpty];
    }
    ((UIAlertAction *)self.changePasswordAlertController.actions.lastObject).enabled = enable;
    
    NSString *s1 = ((UITextField *)self.changePasswordAlertController.textFields[1]).text;
    NSString *s2 = ((UITextField *)self.changePasswordAlertController.textFields[2]).text;
    
    enable = enable && [s1 isEqualToString:s2];
    
    self.changePasswordAlertController.message = s1.length == s2.length && ![s1 isEqualToString:s2] ? @"Oops! You entered two different new passwords.": @"";
    
    NSLog(@"New state for %@: %d", ((UIAlertAction *)self.changePasswordAlertController.actions.lastObject).title, enable);
  }];
}

- (IBAction)changePassword:(id)sender
{
  self.changePasswordAlertController = [UIAlertController alertControllerWithTitle:@"Change Password" message:nil preferredStyle:UIAlertControllerStyleAlert];
  [self.changePasswordAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
  
  __block RingProfileBasicInfoViewController *weakSelf = self;
  
  [self.changePasswordAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    [weakSelf initPasswordTextfield:textField];
    textField.placeholder = @"Current Password";
    textField.returnKeyType = UIReturnKeyNext;
  }];
  [self.changePasswordAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    [weakSelf initPasswordTextfield:textField];
    textField.placeholder = @"New Password";
    textField.returnKeyType = UIReturnKeyNext;
  }];
  [self.changePasswordAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    [weakSelf initPasswordTextfield:textField];
    textField.placeholder = @"New Password";
    textField.returnKeyType = UIReturnKeySend;
  }];
  
  // ideally, the update button should be of style UIAlertActionStyleDestructive
  // unfortunately, however, that style doesn't allow disabling the button
  UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [RingAuthUser changePasswordWithCurrentPassword:((UITextField *)self.changePasswordAlertController.textFields.firstObject).text
                                        newPassWord:((UITextField *)self.changePasswordAlertController.textFields.lastObject).text
                                            success:nil];
  }];
  addAction.enabled = NO;
  [self.changePasswordAlertController addAction:addAction];
  
  [self presentViewController:self.changePasswordAlertController animated:YES completion:nil];
}
@end
