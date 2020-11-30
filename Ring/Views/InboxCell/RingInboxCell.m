//
//  RingInboxCell.m
//  Ring
//
//  Created by Medpats on 5/6/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingInboxCell.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingDoctorProfileViewController.h"
#import "NSArray+Compare.h"

@interface RingInboxCell()
@property (strong, nonatomic) IBOutlet UILabel *doctorNameText;
@property (strong, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UIView *profileStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountText;
@end
@implementation RingInboxCell

+ (NSString *)nibName
{
  return IS_IPAD ? @"InboxCell_ipad" : @"InboxCell";
}

- (void)setConversation:(RingConversation *)conversation
{
  _conversation = conversation;
  [self updateValues];
}

- (RingMessage *)message
{
  return self.conversation.latestMessage;
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
  doctorProfile.doctor = [self.conversation.latestMessage user];
  [[RingNavigationController sharedNavigationController] pushViewController:doctorProfile animated:YES];
}

- (void)decorateUIs
{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.doctorNameText.font = [UIFont ringFontOfSize:15];
  self.contentText.font = [UIFont ringFontOfSize:12];
  self.contentText.textColor = [UIColor ringDarkGrayColor];
  
  [self.profileStatus decorateCircle];

  self.priceText.textColor = [UIColor ringLightMainColor];
  self.priceText.font = [UIFont ringFontOfSize:8];
  self.unreadCountText.font = [UIFont ringFontOfSize:8];
  self.unreadCountText.backgroundColor = [UIColor ringOrangeColor];
  self.unreadCountText.text = @"!";
  [self.unreadCountText decorateEclipseWithRadius:3];
}

- (void)updateValues
{
  NSString *title;
  NSAttributedString *attributeString;
  if ([self.message.sender.userId isEqualToNumber:currentUser.userId]) {
    title = [NSString stringWithFormat:@"To %@", self.conversation.otherUser.name];
    attributeString = [title attributedStringWithFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize] color:[UIColor ringDarkGrayColor] inRange:NSMakeRange(0, 2) andFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize] color:[UIColor ringMainColor]];
  } else {
    title = [NSString stringWithFormat:@"From %@", self.conversation.otherUser.name];
    attributeString = [title attributedStringWithFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize] color:[UIColor ringDarkGrayColor] inRange:NSMakeRange(0, 4) andFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize] color:[UIColor ringMainColor]];
  }
  
  if ([[self.conversation otherUser] isOnline]) {
    self.profileStatus.backgroundColor = [UIColor ringMainColor];
  } else {
    self.profileStatus.backgroundColor = [UIColor ringOffLineColor];
  }
  
  self.doctorNameText.attributedText = attributeString;
  
//  self.doctorNameText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
//  self.doctorNameText.textColor = [UIColor redColor];
//  self.doctorNameText.text = self.conversation.otherUser.name;
  
  if([self.message hasAttach]) {
    self.contentText.textColor = [UIColor blackColor];
    self.contentText.text = self.message.attachFile.name;
  } else {
    self.contentText.attributedText = [self.message.content attributedHTMLContent];
  }
  self.contentText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  self.priceText.text = [self.message.createdAt distanceTo:[NSDate date]];
  [self.imageProfile loadImageFromUrl:[NSURL URLWithString:self.conversation.otherUser.avatar] placeholder:[UIImage imageNamed:@"default-avatar"]];
  
  self.unreadCountText.hidden = ![ringDelegate.unreadConversationIds containsNumber:self.conversation.otherUser.userId];
}

@end
