//
//  RingPaymentRequestViewController.m
//  Ring
//
//  Created by Medpats on 5/12/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPaymentRequestViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingPurchaseViewController.h"

#define HEADER_HEIGHT 30
#define LABEL_TAG 43

@interface RingPaymentRequestViewController ()<UITextFieldDelegate, PickerViewControllerDelegate> {
  PickerViewController *expirationDateViewController;
}
@property (weak, nonatomic) IBOutlet UILabel *subPaymentText;
@property (weak, nonatomic) IBOutlet UILabel *paymentTitle;
@property (weak, nonatomic) IBOutlet UITextField *cardHolderText;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberText;
@property (weak, nonatomic) IBOutlet UITextField *cardCodeText;
@property (weak, nonatomic) IBOutlet UITextField *expirationDate;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) RingCreditCard *card;
@end

@implementation RingPaymentRequestViewController

- (RingCreditCard *)card
{
  if (!_card) {
    _card = [RingCreditCard createEmpty];
  }
  return _card;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = [NSString stringWithFormat:@"Ring %@", self.doctor.name];
  [self decorateWhitebackground];
  [self decorateUIs];
  
  if(currentUser.name != nil) {
    self.cardHolderText.text = currentUser.name;
    self.card.holder = currentUser.name;
  }
  
  [self initGestures];
  
  [self initExpirationDateEditor];
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
  for(UITextField *t in @[self.cardHolderText, self.cardNumberText, self.cardCodeText, self.expirationDate]) {
    [t decorateEclipseWithRadius:3];
    [t decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
    t.textColor = [UIColor blackColor];
    t.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  }
  
  self.paymentTitle.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.paymentTitle.textColor = [UIColor blackColor];
  
  self.subPaymentText.textColor = [UIColor ringLightMainColor];
  self.subPaymentText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  
  [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.submitButton.backgroundColor = [UIColor ringOrangeColor];
  self.submitButton.titleLabel.font = [UIFont boldRingFontOfSize:14];
}

- (IBAction)submitPaymentPressed:(id)sender {
  if ([self.card validateFields]) {
    RingPurchaseViewController *purchaseView = (RingPurchaseViewController *)[RingUtility getViewControllerWithName:@"purchaseView"];
    purchaseView.request = self.callRequest;
    purchaseView.card = self.card;
    [self.navigationController pushViewController:purchaseView animated:YES];
  }
}

- (void)initExpirationDateEditor {
  NSInteger currentYear = [NSDate currentYear];
  NSMutableArray *yearTitles = [NSMutableArray new];
  NSMutableArray *yearValues = [NSMutableArray new];
  for(NSInteger year = currentYear; year < currentYear + 18; year++) {
    [yearTitles addObject:[NSString stringWithFormat:@"%d", year]];
    [yearValues addObject:@(year)];
  }
  
  NSArray *monthTitles = @[@"January", @"February", @"March", @"April",
                           @"May", @"June", @"July", @"August",
                           @"September", @"October", @"November", @"December"];
  NSArray *monthValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12];
  assert(monthTitles.count == monthValues.count);
  assert(monthValues.count == 12);
  
  expirationDateViewController = [PickerViewController new];
  [expirationDateViewController configureWithTitles:@[monthTitles, yearTitles] tags:@[monthValues, yearValues]];
  expirationDateViewController.delegate = self;
  
  self.expirationDate.inputView = expirationDateViewController.view;
}

# pragma mark -- PickerViewControllerDelegate
- (void)pickerViewController:(PickerViewController *)pvc didSelectTitles:(NSArray *)titles withTags:(NSArray *)values
{
  self.card.expireMonth = values[0];
  self.card.expireYear = values[1];
  self.expirationDate.text = [NSString stringWithFormat:@"%@ %@", titles[0], self.card.expireYear];
}

#pragma mark -- TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField == self.cardHolderText) {
    [self.cardNumberText becomeFirstResponder];
  } else if(textField == self.cardNumberText) {
    [self.cardCodeText becomeFirstResponder];
  } else if(textField == self.cardCodeText) {
    [self.expirationDate becomeFirstResponder];
  } else if(textField == self.expirationDate) {
    [self submitPaymentPressed:textField];
  }
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  if (textField == self.cardNumberText) {
    self.card.number = textField.text;
  } else if (textField == self.cardHolderText) {
    self.card.holder = textField.text;
  } else if (textField == self.cardCodeText) {
    self.card.code = @([textField.text integerValue]);
  }
}
@end
