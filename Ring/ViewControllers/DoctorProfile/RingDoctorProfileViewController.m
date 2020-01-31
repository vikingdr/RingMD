//
//  RingDoctorProfileViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/6/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingDoctorProfileViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingRequestCallViewController.h"
#import "RingMessagesViewController.h"
#import "RingDoctorInfoView.h"

@interface RingDoctorProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBottomConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (strong, nonatomic) RingDoctorInfoView *doctorInfoView;
@end

@implementation RingDoctorProfileViewController

- (RingDoctorInfoView *)doctorInfoView
{
  if (!_doctorInfoView) {
    _doctorInfoView = [RingDoctorInfoView doctorInfoViewWithDoctor:self.doctor];
    _doctorInfoView.frame = CGRectMake(0, 0, self.scrollViewContainer.frame.size.width, _doctorInfoView.frame.size.height);
    [self.scrollViewContainer addSubview:_doctorInfoView];
    [_doctorInfoView decorateUIs];
  }
  return _doctorInfoView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self observeEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)decorateUIs
{
  RingDoctorInfoView *doctorInfoView = self.doctorInfoView;
  if(doctorInfoView.superview) {
    [doctorInfoView decorateUIs];
  } else {
    [self.scrollViewContainer addSubview:self.doctorInfoView];
  }
  
  if (IS_DOCTOR) {
    [self.bottomView removeFromSuperview];
    self.distanceToBottomConstraint.constant = 0;
  } else {
    self.bottomView.backgroundColor = [UIColor ringWhiteColor];
    self.callButton.backgroundColor = [UIColor ringOrangeColor];
    NSString *title = [NSString stringWithFormat:@"Request a Ring · %@/min", self.doctor.pricePerMinuteText];
    NSAttributedString *attributeText = [title attributedStringWithFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize] color:[UIColor whiteColor] inRange:NSMakeRange(0, 16) andFont:[UIFont boldRingFontOfSize:14] color:[UIColor whiteColor]];
    [self.callButton setAttributedTitle:attributeText forState:UIControlStateNormal];
  }
  
  self.scrollViewContainer.contentSize = CGSizeMake(self.view.frame.size.width, self.doctorInfoView.frame.size.height + self.doctorInfoView.frame.origin.y);
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.doctorInfoView checkUserStatus];
}

- (void)updateInfo
{
  [self decorateUIs];
  
  [self.doctor getFullUserInfoWithSuccess:^{
    [self decorateUIs];
  } modally:[self.doctor.about isEmpty]];
}

#pragma mark --NAVIGATION
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
  if (!currentUser) {
    
  }
  return !!currentUser;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"requestCall"]) {
    RingRequestCallViewController *requestCall = [segue destinationViewController];
    requestCall.doctor = self.doctor;
  } else {
    RingMessagesViewController *messageTo = [segue destinationViewController];
    messageTo.user = self.doctor;
  }
}
@end
