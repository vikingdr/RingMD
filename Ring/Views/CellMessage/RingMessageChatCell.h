//
//  RingMessageChatCell.h
//  Ring
//
//  Created by Medpats on 1/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#ifdef DEBUG
//#define DEBUG_CHAT_CELL 1
#endif

typedef enum {
  RingMessageChatCellHideAvatar,
  RingMessageChatCellShowAvatarAndOverflow,
  RingMessageChatCellShowAvatarAndDoNotOverflow
} RingMessageChatCellAvatarBehavior;

@class RingMessage;

@interface RingMessageChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *senderText;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UILabel *sentTime;
@property (weak, nonatomic) IBOutlet UIImageView *avatarOverlayImage;
@property (weak, nonatomic) IBOutlet UIView *profileStatus;
@property IBOutlet UIView *attachmentView;
@property IBOutlet UIButton *attachmentButton;
@property IBOutlet NSLayoutConstraint *messageTopConstraint;
@property IBOutlet NSLayoutConstraint *attachmentTopConstraint;

@property (weak, nonatomic) RingMessage *message;
@property (weak, nonatomic) UIViewController* delegate;

+ (CGFloat)cellHeightForMessage:(RingMessage *)message avatar:(RingMessageChatCellAvatarBehavior)avatar;

- (void)decorateUIs;
- (void)initGestures;

- (void)decorateAttachFileFromMessage:(RingMessage *)message;

- (void)updateMeUIs;
- (void)updateSenderUIs;
- (void)updateLayout:(BOOL)showAvatar;
@end
