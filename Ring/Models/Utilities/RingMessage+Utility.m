//
//  RingMessage+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/18/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingMessage+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingMessage (Utility)
+ (NSArray *)all
{
  return [[RingData sharedInstance] findEntities:@"RingMessage" withPredicateString:nil andArguments:nil withSortDescriptionKeys:nil];
}

+ (RingMessage *)createEmpty
{
  return [NSEntityDescription insertNewObjectForEntityForName:@"RingMessage" inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
}

+ (RingMessage *)insertWithJSON:(NSDictionary *)jsonData
{
  RingMessage *message = [self createEmpty];
  if (jsonData)
    [message updateAttributeWithJson:jsonData];
  return message;
}

+ (RingMessage *)findById:(NSNumber *)messageId
{
  return (RingMessage *)[[RingData sharedInstance] findSingleEntity:@"RingMessage" withPredicateString:@"messageId == %@" andArguments:@[messageId] withSortDescriptionKey:nil];
}

+ (RingMessage *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key
{
  RingMessage *message = [self findById:[jsonData objectForKey:key]];
  if (message)
    [message updateAttributeWithJson:jsonData];
  else {
    message = [RingMessage insertWithJSON:jsonData];
    message.messageId = @([[jsonData objectForKey:key] integerValue]);
  }
  return message;
}

+ (RingMessage *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  return [self insertOrUpdateWithJSON:jsonData withIdKey:@"id"];
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *messageJson in jsonArray) {
      [results addObject:[RingMessage insertOrUpdateWithJSON:messageJson]];
    }
  }
  return results;
}

- (BOOL)hasAttach
{
  return self.attachFile != nil;
}

- (NSData *)attachData
{
  if ([self hasAttach] && self.attachFile.attachData) {
    return self.attachFile.attachData;
  }
  return nil;
}

- (RingUser *)user
{
  if ([currentUser.userId isEqualToNumber:self.receiver.userId]) {
    return self.sender;
  }
  return self.receiver;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"content" : @"content", @"createdAt" : @"created_at", @"messageId": @"id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  if ([jsonData objectForKey:@"sender_id"]) {
    self.sender = [RingUser findById:[jsonData objectForKey:@"sender_id"]];
    if (self.sender == nil && [jsonData objectForKey:@"user"]) {
      self.sender = [RingUser insertOrUpdateWithJSON:[jsonData objectForKey:@"user"]];
    }
  }
  if ([jsonData objectForKey:@"sender_id"]) {
    self.sender = [RingUser findById:[jsonData objectForKey:@"sender_id"]];
  }
  if ([jsonData objectForKey:@"receiver_id"]) {
    self.receiver = [RingUser findById:[jsonData objectForKey:@"receiver_id"]];
  }
  if(self.sender && self.receiver) {
    self.conversation = [RingConversation conversationForSender:self.sender receiver:self.receiver];
  }
  if ([jsonData objectForKey:@"attach_file"] && ![[jsonData objectForKey:@"attach_file"] isEqual:[NSNull null]]) {
    self.attachFile = [RingAttachFile insertWithJSON:[jsonData objectForKey:@"attach_file"]];  }
}

+ (void)createMessageWithContent:(NSString *)message toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock
{
  if ([message isEmpty]) {
    [UIViewController showMessage:@"Please enter a message" withTitle:@"Form data invalid"];
    return;
  }
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"message" : @{@"receiver_id" : user.userId, @"content": message}} path:messagesPath];
  [self manipulateMessageAfterCreate:operation toUser:user withSuccess:^(RingMessage *message) {
    successBlock();
  }];
}

+ (void)createMessageWithAttachment:(NSString *)url ofContentType:(NSString *)contentType toUser:(RingUser *)user withSuccess:(void(^)(RingMessage *))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"message" : @{@"receiver_id" : user.userId}, @"attach_file" : @{@"content_type" : contentType, @"remote_path_tmp_url": url}} path:messagesPath];
  [self manipulateMessageAfterCreate:operation toUser:user withSuccess:^(RingMessage *message) {
    successBlock(message);
  }];
}

+ (void)createMessageWithImage:(UIImage *)image toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock
{
  UIImage *resizedImage = [image resizeWithToUpLoad];
  [FileUploader uploadImageAttachment:resizedImage proceed:^(NSString *url, NSString *contentType, NSData *data) {
    [RingMessage createMessageWithAttachment:url ofContentType:contentType toUser:user withSuccess:^(RingMessage *msg) {
      msg.attachFile.attachData = data;
      successBlock();
    }];
  }];
}

+ (void)manipulateMessageAfterCreate:(AFHTTPRequestOperation *)operation toUser:(RingUser *)user withSuccess:(void(^)(RingMessage *message))successBlock
{
  [operation perform:^(NSDictionary *json) {
    RingMessage *message = [RingMessage insertWithJSON:json];
    NSMutableSet *messages = [user.receiveMessages mutableCopy];
    [messages addObject:message];
    message.sender = [RingUser currentCacheUser];
    user.receiveMessages = messages;
    if(successBlock)
      successBlock(message);
  } modally:YES];
}

@end
