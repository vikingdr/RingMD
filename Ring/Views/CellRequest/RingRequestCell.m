//
//  RingRequestCell.m
//  Ring
//
//  Created by Medpats on 5/9/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingRequestCell.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "NSArray+Compare.h"
#import "RingDoctorProfileViewController.h"

@interface RingRequestCell()
@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UILabel *subTitleText;
@property (weak, nonatomic) IBOutlet UIView *profileStatus;
@property (weak, nonatomic) IBOutlet UIImageView *requestImageStatus;
@property (weak, nonatomic) IBOutlet UILabel *callTimeText;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountText;
@end

@implementation RingRequestCell
+ (NSString *)nibName
{
  return IS_IPAD ? @"RequestCell_ipad" : @"RequestCell";
}

- (void)setRequest:(RingCallRequest *)request
{
  _request = request;
  [self updateValues];
}

- (RingUser *)user
{
  return self.request.user;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self decorateUIs];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self decorateUIs];
  [self initGestures];
}

- (void)initGestures
{
  if (!IS_DOCTOR) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap)];
    [self.imageProfile addGestureRecognizer:tapGesture];
  }
}

- (void)avatarTap
{
  RingDoctorProfileViewController *doctorProfile = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
  doctorProfile.doctor = [self.request user];
  [[RingNavigationController sharedNavigationController] pushViewController:doctorProfile animated:YES];
}

- (void)decorateUIs
{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.titleText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.titleText.textColor = [UIColor ringMainColor];
  self.statusText.textColor = [UIColor ringOrangeColor];
  [self.profileStatus decorateCircle];
  [self.profileStatus decorateCircle];
  self.callTimeText.textColor = [UIColor ringLightMainColor];
  self.callTimeText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.unreadCountText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].tinyFontSize];
  self.unreadCountText.backgroundColor = [UIColor ringOrangeColor];
  self.unreadCountText.text = @"!";
  [self.unreadCountText decorateEclipseWithRadius:3];
}

- (void)updateValues
{
  if ([self.request.user isOnline]) {
    self.profileStatus.backgroundColor = [UIColor ringMainColor];
  } else {
    self.profileStatus.backgroundColor = [UIColor ringOffLineColor];
  }
  self.titleText.text = self.user.name;
  [self.imageProfile loadImageFromUrl:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"default-avatar"]];
  if (self.request.isAccepted) {
    self.statusText.text = [[self.request acceptedDate] defaultFormat];
    self.requestImageStatus.image = [UIImage imageNamed:@"approved"];
    self.statusText.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
    self.callTimeText.hidden = NO;
    self.callTimeText.text =  [NSString stringWithFormat:@"(%@)", [[self.request acceptedDate] afterDistanceTo:[NSDate date]]];
  } else if (self.request.isRequested){
    self.statusText.text = @"pending";
    self.requestImageStatus.image = [UIImage imageNamed:@"clock-orange"];
    self.statusText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
    self.callTimeText.hidden = YES;
  } else {
    self.statusText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
    self.statusText.text = self.request.state;
    self.requestImageStatus.image = [UIImage imageNamed:@"clock-orange"];
    self.callTimeText.hidden = YES;
  }
  NSString *reason = [NSString stringWithFormat:@"Topic: %@", self.request.reason];
  self.subTitleText.attributedText = [reason attributedStringByBoldInRange:NSMakeRange(0, 5) foregroundColor:[UIColor ringLightMainColor] fontSize:[RingConfigConstant sharedInstance].smallFontSize];
  
  self.unreadCountText.hidden = ![ringDelegate.unreadRequestIds containsNumber:self.request.callRequestId];
}

@end
