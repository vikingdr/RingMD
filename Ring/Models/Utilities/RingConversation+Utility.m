//
//  RingConversation+Utility.m
//  Ring
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingConversation+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingConversation (Utility)
- (RingUser *)otherUser
{
  for(RingUser *user in self.users) {
    if(! [user.userId isEqualToNumber:currentUser.userId]) {
      return user;
    }
  }
  
  return nil;
}

- (void)setOtherUser:(RingUser *)otherUser
{
  assert(! [currentUser.userId isEqualToNumber:otherUser.userId]);
  self.users = [NSSet setWithObjects:RingUser.currentCacheUser, otherUser, nil];
}

+ (NSArray *)inbox
{
  return [[RingData sharedInstance] findEntities:@"RingConversation"
                             withPredicateString:nil
                                    andArguments:nil
                         withSortDescriptionKeys:@{@"latestMessage.createdAt": @NO}];
}

+ (RingConversation *)createEmpty
{
  return [NSEntityDescription
          insertNewObjectForEntityForName:@"RingConversation"
          inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
}

+ (RingConversation *)conversationForSender:(RingUser *)sender receiver:(RingUser *)receiver
{
  assert(sender != nil);
  assert(receiver != nil);
  assert(! [sender.userId isEqualToNumber:receiver.userId]);
  assert([sender.userId isEqualToNumber:currentUser.userId]
         || [receiver.userId isEqualToNumber:currentUser.userId]);
  
  RingUser *otherUser = [sender.userId isEqualToNumber:currentUser.userId] ? receiver : sender;
  
  RingConversation *conversation = [self findConversationById:otherUser.userId];
  if(! conversation) {
    conversation = [self createEmpty];
    conversation.otherUser = otherUser;
  }
  
  return conversation;
}

+ (RingConversation *)findConversationById:(NSNumber *)otherUserId
{
  return (RingConversation *)[[RingData sharedInstance] findSingleEntity:@"RingConversation" withPredicateString:@"ANY users.userId == %@" andArguments:@[otherUserId] withSortDescriptionKey:nil];
}

+ (RingConversation *)insertWithJSON:(NSDictionary *)jsonData
{
  RingConversation *conversation = [self createEmpty];
  if (jsonData) {
    [conversation updateAttributeWithJson:jsonData];
  }
  return conversation;
}

+ (RingConversation *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingUser *sender = nil;
  RingUser *receiver = nil;
  RingUser *otherUser = nil;
  if(jsonData) {
    if ([jsonData objectForKey:@"sender"]) {
      sender = [RingUser insertOrUpdateWithJSON:[jsonData objectForKey:@"sender"]];
      if(! [sender.userId isEqualToNumber:currentUser.userId]) {
        otherUser = sender;
      }
    }
    if ([jsonData objectForKey:@"receiver"]) {
      receiver = [RingUser insertOrUpdateWithJSON:[jsonData objectForKey:@"receiver"]];
      if(! [receiver.userId isEqualToNumber:currentUser.userId]) {
        otherUser = receiver;
      }
    }
  }
  
  RingConversation *conversation = [self findConversationById:otherUser.userId];
  if (conversation) {
    [conversation updateAttributeWithJson:jsonData];
  } else {
    conversation = [RingConversation insertWithJSON:jsonData];
  }
  
  conversation.latestMessage.sender = sender;
  conversation.latestMessage.receiver = receiver;
  conversation.otherUser = otherUser;
  
  return conversation;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *conversationJson in jsonArray) {
      RingConversation *conv = [RingConversation insertOrUpdateWithJSON:conversationJson];
      [results addObject:conv];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  if ([jsonData objectForKey:@"latest_message"] && ![[jsonData objectForKey:@"latest_message"] isEqual:[NSNull null]]) {
    self.latestMessage = [RingMessage insertOrUpdateWithJSON:[jsonData objectForKey:@"latest_message"]];
  }
}

+ (void)loadInboxWithPage:(NSInteger)page success:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"page": @(page), @"per_page": @(perPage)} path:messagesPath];
  [operation perform:^(NSArray *json) {
    RingUser *user = [RingUser currentCacheUser];
    user.conversations = [[NSSet alloc] initWithArray:[RingConversation insertOrUpdateWithJSONArray:json]];
    
    if(successBlock)
      successBlock();
  } modally:page == 1];
}
@end
