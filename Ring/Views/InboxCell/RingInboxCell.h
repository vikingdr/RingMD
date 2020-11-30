//
//  RingInboxCell.h
//  Ring
//
//  Created by Medpats on 5/6/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingConversation;

@interface RingInboxCell : UITableViewCell
@property (weak, nonatomic) RingConversation *conversation;

+ (NSString *)nibName;
@end
