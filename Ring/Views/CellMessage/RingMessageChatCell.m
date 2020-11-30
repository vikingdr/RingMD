//
//  RingMessageChatCell.m
//  Ring
//
//  Created by Medpats on 1/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingMessageChatCell.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingDoctorProfileViewController.h"
#import "RingUserProfileViewController.h"

#define messageFont [UIFont ringFontOfSize:12]

CGFloat yMargin;
CGFloat headerHeight;
CGFloat contentWidth;
CGFloat attachmentHeight;
CGFloat avatarBottom;
UILabel *dummyMessageTextLabel;

void init() {
  static dispatch_once_t initOnce;
  dispatch_once(&initOnce, ^{
    RingMessageChatCell *dummyCell = [[NSBundle mainBundle] loadNibNamed:@"MessageChat" owner:nil options:nil].firstObject;
    assert(dummyCell != nil);
    [dummyCell decorateUIs];
    dummyMessageTextLabel = dummyCell.messageText;
    
    CGRect avf = dummyCell.avatarOverlayImage.frame;
    
    yMargin = avf.origin.y;
    avatarBottom = avf.origin.y + avf.size.height;
    contentWidth = dummyCell.messageText.frame.size.width;
    headerHeight = dummyCell.senderText.frame.size.height;
    attachmentHeight = dummyCell.attachmentView.frame.size.height;
    
#ifdef DEBUG_CHAT_CELL
    NSLog(@"Vertical margin: %f", yMargin);
    NSLog(@"Header height: %f", headerHeight);
    NSLog(@"Content width: %f", contentWidth);
    NSLog(@"Attachment height: %f", attachmentHeight);
    NSLog(@"Avatar bottom: %f", avatarBottom);
#endif
  });
}

CGFloat textHeightForMessage(RingMessage *message) {
  init();
  dummyMessageTextLabel.text = message.content;
  return message.content.isEmpty ? 0 : [dummyMessageTextLabel textRectForBounds:CGRectMake(0, 0, contentWidth, FLT_MAX) limitedToNumberOfLines:0].size.height;
}

@implementation RingMessageChatCell

- (void)setMessage:(RingMessage *)message
{
  _message = message;
  [self updateValues];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self decorateUIs];
}

- (void)updateValues
{
  [self.imageProfile loadImageFromUrl:[NSURL URLWithString:[self.message.sender avatar]] placeholder:[UIImage imageNamed:@"default-avatar"]];
  self.messageText.attributedText = [self.message.content attributedHTMLContent];
  self.messageText.font = messageFont;
  self.sentTime.text = [self.message.createdAt distanceTo:[NSDate date]];
  self.senderText.text = self.message.sender.name;
  if ([self.message.sender isOnline]) {
    self.profileStatus.backgroundColor = [UIColor ringMainColor];
  } else {
    self.profileStatus.backgroundColor = [UIColor ringOffLineColor];
  }
  if ([self.message.sender.userId isEqualToNumber:currentUser.userId])
  {
    [self updateMeUIs];
  } else {
    [self updateSenderUIs];
  }
}

- (void)decorateUIs
{
#ifdef DEBUG_CHAT_CELL
  self.messageText.backgroundColor = [UIColor greenColor];
  self.attachmentView.backgroundColor = [UIColor blueColor];
#endif
  
  self.messageText.font = messageFont;
  self.sentTime.textColor = [UIColor ringLightMainColor];
  self.sentTime.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.messageText.textColor = [UIColor blackColor];
  self.senderText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  [self.profileStatus decorateCircle];
}

- (void)avatarTap
{
  RingUser *user = self.message.sender;
  if ([user.userId isEqual:currentUser.userId]) {
    RingUserProfileViewController *userProfile = (RingUserProfileViewController *)[RingUtility getViewControllerWithName:@"userProfile"];
    userProfile.user = user;
    [[RingNavigationController sharedNavigationController] pushViewController:userProfile animated:YES];
  } else {
    RingDoctorProfileViewController *doctorProfile = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
    doctorProfile.doctor = user;
    [[RingNavigationController sharedNavigationController] pushViewController:doctorProfile animated:YES];
  }
}

- (void)initGestures
{
  if (!IS_DOCTOR) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap)];
    [self.imageProfile addGestureRecognizer:tapGesture];
  }
  
  //  [self.attachImage removeGestureRecognizer:nil];
  //  self.attachImage.userInteractionEnabled = YES;
  //  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
  //                                   initWithTarget:self action:@selector(handleAttachTap:)];
  //  tgr.delegate = self;
  //  [self.attachImage addGestureRecognizer:tgr];
}

+ (CGFloat)cellHeightForMessage:(RingMessage *)message avatar:(RingMessageChatCellAvatarBehavior)avatar;
{
  init();
  
  CGFloat height = textHeightForMessage(message);
  
  if(message.hasAttach) {
    height += attachmentHeight;
  }
  
  height += yMargin;
  
  if(avatar != RingMessageChatCellHideAvatar) {
    height += headerHeight;
    if(avatar == RingMessageChatCellShowAvatarAndDoNotOverflow) {
      height = MAX(avatarBottom, height);
    }
    height += yMargin;
  }
  
  return height;
}

- (void)updateLayout:(BOOL)showAvatar
{
  init();
  
  self.senderText.hidden = self.sentTime.hidden = self.profileStatus.hidden = self.imageProfile.hidden = self.avatarOverlayImage.hidden = !showAvatar;
  
  self.messageTopConstraint.constant = (showAvatar ? yMargin + headerHeight : 0);
  
  self.attachmentTopConstraint.constant = self.messageTopConstraint.constant + textHeightForMessage(self.message);
}

- (void)updateMeUIs
{
  self.backgroundColor = [UIColor whiteColor];
  self.senderText.textColor = [UIColor ringLightMainColor];
  self.avatarOverlayImage.image = [UIImage imageNamed:@"avatar-bg"];
}

- (void)updateSenderUIs
{
  self.backgroundColor = [UIColor ringWhiteColor];
  self.senderText.textColor = [UIColor ringMainColor];
  self.avatarOverlayImage.image = [UIImage imageNamed:@"avatar-bg"];
}

- (void)decorateAttachFileFromMessage:(RingMessage *)message
{
  [self.attachmentButton setTitle:message.attachFile.name forState:UIControlStateNormal];
  self.attachmentView.hidden = !message.hasAttach;
}

- (IBAction)openAttachment:(UIView *)sender
{
  [self.message.attachFile fetchDataWithSuccessBlock:^{
    [self.delegate presentFile:self.message.attachFile.tempFileURL withView:sender];
  }];
}
@end
