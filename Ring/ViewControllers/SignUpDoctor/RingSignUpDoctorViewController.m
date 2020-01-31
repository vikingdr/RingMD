//
//  TourSignUpView.m
//  TourNative
//
//  Created by Medpats on 4/4/2557 BE.
//  Copyright (c) 2557 TourNative. All rights reserved.
//

#import "RingSignUpDoctorViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingCountryChooserViewController.h"
#import "RingCountryCodeViewController.h"
#import "RingMedicalSchoolSearchViewController.h"
#import "RingMedicalSchool.h"
#import "RingInputWithUnit.h"
#import "RingSpecialitiesPickerViewController.h"

#define HEADER_HEIGHT 44

@interface RingSignUpDoctorViewController()<UITextFieldDelegate, /*MedialSearchDelegate,*/ RingCountryChooserDelegate, PickerViewControllerDelegate, RingCountryCodeViewControllerDelegate, RingSpecialitiesPickerViewControllerDelegate, UIScrollViewDelegate, NavigationBarOptions>
{
  UITextField *activeField;
  NSInteger selectedIndexPicker;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIView *signUpContainer1;
@property (weak, nonatomic) IBOutlet UIView *signUpContainer2;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet RingTextField *rateText;
@property (weak, nonatomic) IBOutlet UITextField *licenseNumberText;
@property (weak, nonatomic) IBOutlet RingTextField *countryText;
@property (weak, nonatomic) IBOutlet RingTextField *specialityText;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIScrollView *signUpScrollViewContainer;
@property (weak, nonatomic) IBOutlet RingTextField *phoneCodeText;
@property (weak, nonatomic) IBOutlet UITextField *phoneRawNumberText;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintContainer2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintContainer2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (strong, nonatomic) RingAuthUser *user;
@property (strong, nonatomic) RingCountry *selectedCountry;
@property (strong, nonatomic) RingSpeciality *selectedSpeciality;
//@property (strong, nonatomic) NSString *selectedMedicalSchool;
@end

@implementation RingSignUpDoctorViewController

- (RingAuthUser *)user {
  if (!_user) {
    _user = [RingAuthUser createEmptyUser];
  }
  return _user;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initGestures];
  [self decorateUIs];
  
  [self initPhoneCodeWidget];
  [self initRateChooser];
  [self initCountryChooser];
  [self initSpecialitiesChooser];
  
  self.signUpScrollViewContainer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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
  [self.signUpContainer1 decorateEclipseWithRadius:3];
  [self.signUpContainer2 decorateEclipseWithRadius:3];
  [self.signUpButton decorateEclipseWithRadius:3];
  [self.nextButton decorateEclipseWithRadius:3];
  
  [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.signUpButton.backgroundColor = [UIColor ringMainColor];
  self.signUpButton.titleLabel.font = [UIFont boldRingFontOfSize:16];
  [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.nextButton.backgroundColor = [UIColor ringMainColor];
  self.nextButton.titleLabel.font = [UIFont boldRingFontOfSize:16];
  
  for (UITextField *textField in @[_firstNameText, _passwordText, _phoneCodeText, _phoneRawNumberText, _emailText, _rateText, _licenseNumberText, _countryText, _specialityText]) {
    textField.textColor = [UIColor blackColor];
    [textField decorateEclipseWithRadius:3];
    [textField decorateBorder:1 andColor:[UIColor lightGrayColor]];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont ringFontOfSize:14];
  }
  
  _rateText.placeholder = @"International Rate per Hour";
  _rateText.delegate = self;
  
  [self.signInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  self.signInButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  if(! IS_IPAD && self.signUpContainer2) {
    [self.signUpScrollViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container1][container2]|" options:0 metrics: 0 views:@{@"container1": self.signUpContainer1, @"container2": self.signUpContainer2}]];
  }
  
  // On the iPad we vertically stack signUpContainer1 and signUpContainer2, and we hide the 'next' button
  if(IS_IPAD && self.signUpContainer2) {
    self.nextButton.hidden = YES;
    
    NSLayoutConstraint *newLeftConstraint = [NSLayoutConstraint constraintWithItem:self.signUpContainer2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.signUpContainer1 attribute:NSLayoutAttributeLeft multiplier:0 constant:0];
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.signUpContainer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phoneCodeText attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    
    [self.signUpScrollViewContainer removeConstraint:self.leftConstraintContainer2];
    [self.signUpScrollViewContainer removeConstraint:self.topConstraintContainer2];
    [self.signUpScrollViewContainer addConstraint:newTopConstraint];
    [self.signUpScrollViewContainer addConstraint:newLeftConstraint];
    
    self.heightConstraint.constant = self.heightConstraint.constant * 2 - self.nextButton.frame.size.height;
  }
}

- (IBAction)showSignInPressed:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)resetScrollView
{
  [self.signUpScrollViewContainer scrollRectToVisible:self.signUpContainer1.frame animated:YES];
}

- (IBAction)nextButtonPressed:(id)sender {
  [self.signUpScrollViewContainer scrollRectToVisible:self.signUpContainer2.frame animated:YES];
  [activeField resignFirstResponder];
}

- (IBAction)signUpPressed:(id)sender {
  self.user.email = self.emailText.text;
  self.user.name = self.firstNameText.text;
  self.user.password = self.passwordText.text;
  self.user.phoneCode = self.phoneCodeText.text;
  self.user.phoneRawNumber = self.phoneRawNumberText.text;
  self.user.isDoctor = @(YES);
  
  if (![self.user validateFields] || ![self.user validateDoctorFields]) {
    [self resetScrollView];
    return;
  }
  
  if(self.user.pricePerHourValue <= 0) {
    [UIViewController showMessage:@"Please enter your hourly rate" withTitle:@"Form data invalid"];
    return;
  }
  
  if(self.licenseNumberText.text.length == 0) {
    [UIViewController showMessage:@"Please enter your license number" withTitle:@"Form data invalid"];
    return;
  }
  
  if(self.selectedCountry == nil) {
    [UIViewController showMessage:@"Please enter your country" withTitle:@"Form data invalid"];
    return;
  }
  
  if (self.selectedSpeciality == nil) {
    [UIViewController showMessage:@"Please enter your specialty" withTitle:@"Form data invalid"];
    return;
  }
  
  [self.user signUpforDoctorWithCountryId:self.selectedCountry.countryId andSpecialityId:self.selectedSpeciality.specialityId licenseNumber:self.licenseNumberText.text success:^{
    [[RingNavigationController sharedNavigationController] pushUserDefaultViewController:YES];
  }];
}

- (void)initPhoneCodeWidget {
  RingCountryCodeViewController *controller = [[RingCountryCodeViewController alloc] initWithNibName:@"RingCountryCodeViewController" bundle:nil];
  controller.delegate = self;
  [self.phoneCodeText setInputViewController:controller];
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
- (void)initRateChooser
{
  const int maxAmount = 1000;
  NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:maxAmount - 1];
  NSMutableArray *vals = [[NSMutableArray alloc] initWithCapacity:maxAmount - 1];
  for(int i = 1; i <= maxAmount; i++) {
    [titles addObject:[NSString stringWithFormat:@"%d", i]];
    [vals addObject:@(i)];
  }
  
  PickerViewController *pvc = [PickerViewController new];
  [pvc configureWithTitles:@[@[@"$", @"S$"], titles] tags:@[@[@"usd", @"sgd"], vals]];
  pvc.delegate = self;
  [self.rateText setInputViewController:pvc];
}

- (void)initCountryChooser
{
  RingCountryChooserViewController *rccvc = [RingCountryChooserViewController new];
  rccvc.delegate = self;
  [self.countryText setInputViewController:rccvc];
}

//- (void)showMedicalSearch
//{
//  RingMedicalSchoolSearchViewController *mssvc = [RingMedicalSchoolSearchViewController new];
//  mssvc.implicitSchool = self.selectedMedicalSchool;
//  mssvc.delegate = self;
//  [self presentPopupViewController:mssvc animated:YES completion:nil];
//}

- (void)initSpecialitiesChooser
{
  RingSpecialitiesPickerViewController *controller = [[RingSpecialitiesPickerViewController alloc] initWithNibName:@"RingSpecialitiesPickerViewController" bundle:nil];
  controller.delegate = self;
  [self.specialityText setInputViewController:controller];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  _scrollViewContainer.contentSize = _scrollViewContainer.frame.size;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (textField == self.rateText || textField == self.countryText || textField == self.specialityText) {
    return NO;
  }
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.specialityText) {
    [self signUpPressed:nil];
  } else if (textField == self.emailText){
    [self.firstNameText becomeFirstResponder];
  } else if (textField == self.firstNameText) {
    [self.passwordText becomeFirstResponder];
  } else if (textField == self.passwordText) {
    [self.phoneCodeText becomeFirstResponder];
  } else if(textField == self.phoneCodeText) {
    [self.phoneRawNumberText becomeFirstResponder];
  } else if (textField == self.phoneRawNumberText) {
    [textField  resignFirstResponder];
    [self nextButtonPressed:nil];
  } else if (textField == self.rateText) {
    [self.licenseNumberText becomeFirstResponder];
  } else if (textField == self.licenseNumberText) {
    [self.countryText becomeFirstResponder];
  } else if (textField == self.countryText) {
    [self.specialityText becomeFirstResponder];
  } else if (textField == self.specialityText) {
    [self signUpPressed:textField];
  }
  return YES;
}

#pragma mark -

#pragma mark PickerViewControllerDelegate
- (void)pickerViewController:(PickerViewController *)pickerViewController didSelectTitles:(NSArray *)titles withTags:(NSArray *)tags
{
  self.user.pricePerHour = tags[1];
  self.user.currency = tags[0];
  self.rateText.text = [NSString stringWithFormat:@"%@ %@/hour", titles[0], self.user.pricePerHour];
}

#pragma mark RingCountryChooserDelegate
- (void)didSelectcountry:(RingCountry *)country
{
  self.selectedCountry = country;
  self.countryText.text = country.name;
}

- (NSString *)selectedCountry
{
  return self.countryText.text;
}

//#pragma mark --RingMedicalSchoolDelegate
//- (void)didSelectMedicalSchool:(NSString *)medicalSchool
//{
//  self.selectedMedicalSchool = medicalSchool;
//  self.licenseNumberText.text = medicalSchool;
//  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}

#pragma mark --RingSPecialityDelegate
- (void)RingSpecialitySelected:(RingSpeciality *)speciality
{
  self.specialityText.text= [speciality name];
  self.selectedSpeciality = speciality;
}

# pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [activeField resignFirstResponder];
  activeField = nil;
}

- (BOOL)shouldShowNavigationBar
{
  return NO;
}
@end
