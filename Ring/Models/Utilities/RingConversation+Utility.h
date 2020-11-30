//
//  RingConversation+Utility.h
//  Ring
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingConversation.h"

@interface RingConversation (Utility)
@property RingUser *otherUser;

+ (NSArray *)inbox;
+ (RingConversation *)conversationForSender:(RingUser *)sender receiver:(RingUser *)receiver;
+ (void)loadInboxWithPage:(NSInteger)page success:(void(^)(void))successBlock;
@end
