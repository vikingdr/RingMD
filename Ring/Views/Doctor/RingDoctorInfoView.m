//
//  RingDoctorInfoView.m
//  Ring
//
//  Created by Medpats on 12/18/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingDoctorInfoView.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingMessagesViewController.h"

#define COLLECTION_ID @"collectionCell"

@interface RingDoctorInfoView() {
  NSURL *_prevProfilePictureImageUrl;
}
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UILabel *firstSpealityView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIView *statusProfile;


@property (weak, nonatomic) IBOutlet UIView *actionsContainer;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIImageView *locationIcon;
@end

@implementation RingDoctorInfoView
+ (id)doctorInfoViewWithDoctor:(RingUser *)doctor
{
  RingDoctorInfoView *customView = [[[NSBundle mainBundle] loadNibNamed:@"DoctorInfoView" owner:nil options:nil] lastObject];
  if ([customView isKindOfClass:[RingDoctorInfoView class]]) {
    customView.doctor = doctor;
    return customView;
  }
  return nil;
}

- (void)checkUserStatus
{
  if ([self.doctor isOnline]) {
    self.statusProfile.backgroundColor = [UIColor ringMainColor];
  } else {
    self.statusProfile.backgroundColor = [UIColor ringOffLineColor];
  }
}

- (void)decorateUIs
{
  NSURL *newProfilePictureUrl = self.doctor.bestQualityAvatarUrl;
  if(! [newProfilePictureUrl isEqual:_prevProfilePictureImageUrl]) {
    [self.profilePictureImage loadImageResizeToFitFromUrl:newProfilePictureUrl placeholder:nil];
    _prevProfilePictureImageUrl = newProfilePictureUrl;
  }
  
  [self.statusProfile decorateCircle];
  [self checkUserStatus];
  self.profileName.text = self.doctor.name;
  self.profileName.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  
  self.firstSpealityView.text = [self.doctor firstSpeciality];
  self.firstSpealityView.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.firstSpealityView.textColor = [UIColor ringMainColor];
  
  self.locationView.text = self.doctor.location;
  self.locationView.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.locationView.textColor = [UIColor ringDarkGrayBGColor];
  [self.locationView sizeToFit];
  [self.locationView layoutIfNeeded];
  self.locationView.textColor = [UIColor ringLightMainColor];
  self.locationIcon.hidden = self.doctor.location == nil;
  
  self.backgroundColor = [UIColor whiteColor];
  if (self.doctor.about && ![self.doctor.about isEmpty]) {
    self.descriptionText.attributedText = [self.doctor.about attributedHTMLContent];
  } else {
    self.descriptionText.text = @"No introduction provided";
  }
  [self.descriptionText setPreferredMaxLayoutWidth:self.frame.size.width];
  self.descriptionText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.descriptionText.textColor = [UIColor ringDarkGrayBGColor];

  [self.messageButton setTitleColor:[UIColor ringDarkGrayBGColor] forState:UIControlStateNormal];
  [self.favoriteButton setTitleColor:[UIColor ringDarkGrayBGColor] forState:UIControlStateNormal];
  self.messageButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.favoriteButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.actionsContainer decorateEclipseWithRadius:3];
  [self.actionsContainer decorateBorder:1 andColor:[UIColor lightGrayColor]];
  if (self.doctor.location && ![self.doctor.location isEmpty]) {
    [self addSubview:self.locationIcon];
  }
  
  if (IS_DOCTOR) {
    self.actionsContainer.hidden = YES;
  } else {
    [self updateFavoriteButton];
  }
  
  [self layoutIfNeeded];

  CGRect frame = self.frame;
  frame.size.height = self.actionsContainer.frame.origin.y + self.actionsContainer.frame.size.height + 20;
  self.frame = frame;
}

- (void)updateFavoriteButton
{
  if ([[RingUser currentCacheUser] isFavorited:self.doctor]) {
    [self.favoriteButton setTitle:@"Remove Favorite" forState:UIControlStateNormal];
  } else {
    [self.favoriteButton setTitle:@"Make Favorite" forState:UIControlStateNormal];
  }
}

- (IBAction)favoritePressed:(id)sender {
  if ([[RingUser currentCacheUser] isFavorited:self.doctor]) {
    [[RingUser currentCacheUser] removeUser:self.doctor fromFavoritesSuccess:^{
      [self updateFavoriteButton];
    }];
  } else {
    [[RingUser currentCacheUser] addUser:self.doctor toFavoritesSuccess:^{
      [self updateFavoriteButton];
    }];
  }
}

- (IBAction)messagePressed:(id)sender {
  RingMessagesViewController *messageView = (RingMessagesViewController *)[RingUtility getViewControllerWithName:@"messages"];
  messageView.user = self.doctor;
  [[RingNavigationController sharedNavigationController] pushViewController:messageView animated:YES];
}
@end
