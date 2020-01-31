//
//  MinglePusher.m
//  Mingle
//
//  Created by East Agile on 3/4/13.
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "RingPusher.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"
#import "Reachability.h"
#import "NSMutableArray+Number.h"

#define ONLINE_CHANNEL @"online"

@implementation RingPusher

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initPusher];
    }
    return self;
}

- (NSMutableDictionary *)pendingChannels
{
  if (!_pendingChannels) {
    _pendingChannels = [NSMutableDictionary dictionary];
  }
  return _pendingChannels;
}

- (void)initPusher
{
  self.pusherClient = [PTPusher pusherWithKey:pusherApiKey delegate:self encrypted:NO];
  self.pusherClient.authorizationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pusher/auth.json", serverAddress, apiVersionPath]];
  [self.pusherClient connect];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEventNotification:) name:PTPusherEventReceivedNotification object:self.pusherClient];
}

- (void)subscribeToChannel:(NSString *)channelName withEvents:(NSArray *)events
{
  if (!self.pusherClient.connection.isConnected) {
    [self.pendingChannels addEntriesFromDictionary:@{channelName : events}];
  } else if (![[self.pusherChannels objectForKey:channelName] isSubscribed]) {
    
    PTPusherChannel *channel;
    if ([channelName isEqualToString:[currentUser channelName]]) {
      channel = [self.pusherClient subscribeToPrivateChannelNamed:channelName];
    } else if ([channelName isEqualToString:ONLINE_CHANNEL]) {
      channel = [self.pusherClient subscribeToPresenceChannelNamed:channelName delegate:self];
    } else {
      channel = [self.pusherClient subscribeToChannelNamed:channelName];
    }
    
    for (NSString *event in events) {
      [channel bindToEventNamed:event handleWithBlock:^(PTPusherEvent *channelEvent){}];
    }
    [self.pusherChannels setObject:channel forKey:channelName];
  }
}

- (void)unsubscribeFromChannel:(NSString *)channelName
{
    PTPusherChannel *channel = [self.pusherChannels objectForKey:channelName];
    [channel unsubscribe];
}

- (BOOL)isContainChannel:(NSString *)channelName
{
  return !![self.pusherChannels objectForKey:channelName];
}

- (BOOL)isSubscribedToChannel:(NSString *)channelName
{
    return [[self.pusherChannels objectForKey:channelName] isSubscribed];
}

- (NSMutableDictionary *)pusherChannels
{
    if (!_pusherChannels)
        _pusherChannels = [NSMutableDictionary new];
    return _pusherChannels;
}

- (void)didReceiveEventNotification:(NSNotification *)notification
{
  PTPusherEvent *event = [notification.userInfo objectForKey:PTPusherEventUserInfoKey];
  [self broadcastPusherEvent:event];
}

- (void)broadcastPusherEvent:(PTPusherEvent *)event {
  NSLog(@"Broadcast %@", [event name]);
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  NSString *eventName = [event name];
  NSDictionary *data = [event data];
    [center postNotificationName:eventName object:nil userInfo:data];
}

+ (RingPusher *)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void)getAllOnlineUser
{
  if (![self isSubscribedToChannel:ONLINE_CHANNEL]) {
    [self subscribeToChannel:ONLINE_CHANNEL withEvents:@[]];
  }
}

- (void)presenceChannelDidSubscribe:(PTPusherPresenceChannel *)channel
{
  [ringDelegate setOnlineUserIds:nil];
  [channel.members enumerateObjectsUsingBlock:^(PTPusherChannelMember *obj, BOOL *stop) {
    [[ringDelegate onlineUserIds] addObject:@([obj.userID integerValue])];
  }];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberAdded:(PTPusherChannelMember *)member
{
  if (member == nil) {
    [self presenceChannelDidSubscribe:channel];
    return;
  }
  NSNumber *userID;
  if ([member.userID isKindOfClass:[NSNumber class]]) {
    userID = (NSNumber *)member.userID;
  } else {
    userID =  @([member.userID integerValue]);
  }
  [[ringDelegate onlineUserIds] addObject:userID];
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userStatusChanged object:nil];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberRemoved:(PTPusherChannelMember *)member
{
  if (member == nil) {
    [self presenceChannelDidSubscribe:channel];
  } else {
    NSNumber *userID;
    if ([member.userID isKindOfClass:[NSNumber class]]) {
      userID = (NSNumber *)member.userID;
    } else {
      userID =  @([member.userID integerValue]);
    }
    [ringDelegate.onlineUserIds removeNumber:userID];
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userStatusChanged object:nil];
}

#pragma mark PTPusherDelegate
- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
  if ([[channel name] isEqualToString:[currentUser fullChannelName]]) {
    [self getAllOnlineUser];
  }
}

- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel
{
  if (!currentUser) {
    [self.pusherChannels removeAllObjects];
  } else if ([[channel name] isEqualToString:[currentUser fullChannelName]]) {
     [self unsubscribeFromChannel:ONLINE_CHANNEL];
    [self.pusherChannels removeObjectForKey:[currentUser channelName]];
  } else {
    [self.pusherChannels removeObjectForKey:ONLINE_CHANNEL];
  }
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannel:(PTPusherChannel *)channel withRequest:(NSMutableURLRequest *)request
{
  if (currentUser) {
    NSString *bodyString = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"%@&user_token=%@", bodyString, currentUser.authToken];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
  }
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect;
{
  [currentUser unSubscribe];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
  [self subscribeToPendingChannels];
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{

}

- (void)subscribeToPendingChannels
{
  for (NSInteger i = 0; i < self.pendingChannels.count; ++i) {
    NSString *channel = [[self.pendingChannels allKeys] objectAtIndex:i];
    NSArray *events = [self.pendingChannels valueForKey:channel];
    [self subscribeToChannel:channel withEvents:events];
  }
  self.pendingChannels = nil;
}

- (void)connect
{
  [self.pusherClient connect];
}

@end
