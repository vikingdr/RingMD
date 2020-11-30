//
//  RingDoctorCell.m
//  Ring
//
//  Created by Medpats on 1/14/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingDoctorCell.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingMessagesViewController.h"
#import "RingRequestCallViewController.h"
#import "MGSwipeButton.h"

@interface RingDoctorCell()
@property (strong, nonatomic) IBOutlet UILabel *doctorNameText;
@property (strong, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UIView *profileStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *reviewText;

@end

@implementation RingDoctorCell

-(void)setUser:(RingUser *)user
{
  _user = user;
  [self updateValues];
  [self configureSwipeButtons];
}

+ (NSString *)nibName
{
  return IS_IPAD ? @"DoctorCell_ipad" : @"DoctorCell";
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
}

- (void)decorateUIs
{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.accessoryType = UITableViewCellAccessoryNone;
  self.doctorNameText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  self.locationText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.locationText.textColor = [UIColor ringDarkGrayColor];
  self.reviewText.textColor = [UIColor ringDarkGrayColor];
  self.reviewText.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.profileStatus decorateCircle];
}

- (void)updateValues
{
  if ([self.user isOnline]) {
    self.profileStatus.backgroundColor = [UIColor ringMainColor];
  } else {
    self.profileStatus.backgroundColor = [UIColor ringOffLineColor];
  }
  self.doctorNameText.text = self.user.name;
  //  self.locationText.text = self.user.location;
  self.locationText.text = [self.user firstSpeciality];
  self.priceText.text = [NSString stringWithFormat:@"%@/min", self.user.pricePerMinuteText];
  [self.imageProfile loadImageFromUrl:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"default-avatar"]];
  NSRange textRange = [self.priceText.text rangeOfString:[NSString stringWithFormat:@"%@", self.user.pricePerMinuteText]];
  [self.priceText setAttributedText:[self.priceText.text attributedStringByBoldInRange:textRange foregroundColor:[UIColor ringDarkGrayColor] fontSize:[RingConfigConstant sharedInstance].textFontSize]];
  self.reviewText.text = @"5.0";
}

- (void)configureSwipeButtons
{
  self.rightButtons = @[[MGSwipeButton buttonWithTitle:@""
                                                  icon:[UIImage imageNamed:@"call-icon"]
                                       backgroundColor:[UIColor redColor]
                                              callback:^BOOL(MGSwipeTableCell *sender) {
                                                [self callPressed:sender];
                                                return YES;
                                              }],
                        [MGSwipeButton buttonWithTitle:@""
                                                  icon:[UIImage imageNamed:@"mail-doctor"]
                                       backgroundColor:[UIColor ringOrangeColor]
                                              callback:^BOOL(MGSwipeTableCell *sender) {
                                                [self mailPressed:sender];
                                                return YES;
                                              }],
                        [MGSwipeButton buttonWithTitle:@""
                                                  icon:[UIImage imageNamed:[[RingUser currentCacheUser] isFavorited:self.user] ? @"favorite-hearted" : @"favorite-doctor"]
                                       backgroundColor:[UIColor lightGrayColor]
                                              callback:^BOOL(MGSwipeTableCell *sender) {
                                                [self favoritePressed:sender];
                                                return YES;
                                              }]];
  self.rightSwipeSettings.transition = MGSwipeTransitionBorder;
}

- (void)callPressed:(id)sender {
  RingRequestCallViewController *requestCall = (RingRequestCallViewController *)[RingUtility getViewControllerWithName:@"callDoctor"];
  requestCall.doctor = self.user;
  [[RingNavigationController sharedNavigationController] pushViewController:requestCall animated:YES];
}

- (void)favoritePressed:(id)sender {
  __block id<RingDoctorCellDelegate> delegate = self.delegate;
  
  if ([[RingUser currentCacheUser] isFavorited:self.user]) {
    [[RingUser currentCacheUser] removeUser:self.user fromFavoritesSuccess:^{
      [delegate doctorCellRefreshUser:self.user];
    }];
  } else {
    [[RingUser currentCacheUser] addUser:self.user toFavoritesSuccess:^{
      [delegate doctorCellRefreshUser:self.user];
    }];
  }
}

- (void)mailPressed:(id)sender {
  RingMessagesViewController *messageView = (RingMessagesViewController *)[RingUtility getViewControllerWithName:@"messages"];
  messageView.user = self.user;
  [[RingNavigationController sharedNavigationController] pushViewController:messageView animated:YES];
}
@end
