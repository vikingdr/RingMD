//
//  MinglePusher.h
//  Mingle
//
//  Created by East Agile on 3/4/13.
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "PTPusherDelegate.h"
#import "PTPusherPresenceChannelDelegate.h"

@class PTPusher;

@interface RingPusher : NSObject <PTPusherDelegate, PTPusherPresenceChannelDelegate>

@property (nonatomic, strong) PTPusher *pusherClient;
@property (nonatomic, strong) NSMutableDictionary *pusherChannels;
@property (nonatomic, strong) NSMutableDictionary *pendingChannels;

+ (RingPusher *)sharedInstance;
- (void)subscribeToChannel:(NSString *)channelName withEvents:(NSArray *)events;
- (void)unsubscribeFromChannel:(NSString *)channelName;
- (BOOL)isSubscribedToChannel:(NSString *)channelName;
- (BOOL)isContainChannel:(NSString *)channelName;
- (void)getAllOnlineUser;
- (void)connect;
@end
