//
//  RingNotification+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/19/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingNotification+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@implementation RingNotification (Utility)
+ (NSArray *)all
{
  return [[RingData sharedInstance] findEntities:@"RingNotification" withPredicateString:nil andArguments:nil withSortDescriptionKeys:@{@"createdAt": @NO}];
}

+ (RingNotification *)insertWithJSON:(NSDictionary *)jsonData
{
  RingNotification *notification = [NSEntityDescription
                    insertNewObjectForEntityForName:@"RingNotification"
                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  notification.notificationId = @([[jsonData objectForKey:@"id"] integerValue]);
  if (jsonData)
    [notification updateAttributeWithJson:jsonData];
  return notification;
}

+ (RingNotification *)findByName:(NSString *)name
{
  return (RingNotification *)[[RingData sharedInstance] findSingleEntity:@"RingNotification" withPredicateString:@"name == %@" andArguments:@[name] withSortDescriptionKey:nil];
}

+ (RingNotification *)findById:(NSNumber *)notificationId
{
  return (RingNotification *)[[RingData sharedInstance] findSingleEntity:@"RingNotification" withPredicateString:@"notificationId == %@" andArguments:@[notificationId] withSortDescriptionKey:nil];
}

+ (RingNotification *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingNotification *notification = [self findById:[jsonData objectForKey:@"id"]];
  if (notification)
    [notification updateAttributeWithJson:jsonData];
  else {
    notification = [RingNotification insertWithJSON:jsonData];
  }
  
  return notification;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *notificationJson in jsonArray) {
      [results addObject:[RingNotification insertOrUpdateWithJSON:notificationJson]];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"message" : @"message", @"createdAt": @"updated_at", @"notificationType": @"object_type", @"notificationObjectId": @"object_id", @"notificationId": @"id"};
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  if ([jsonData objectForKey:@"action_user_id"] && [jsonData objectForKey:@"action_user_id"] != [NSNull null]) {
    self.actionUser = [RingUser insertOrUpdateWithJSON:@{@"id": [jsonData objectForKey:@"action_user_id"], @"full_name" : [jsonData objectForKey:@"action_user_name"]}];
  }
  self.image = [RingUtility fullUrlString:[jsonData objectForKey:@"display_image"]];
}

+ (void)clearRequestsNotification
{
//  if ([[self all] count] == 0) {
//    return;
//  }
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"updated_at" : [[[[RingNotification all] objectAtIndex:0] createdAt] ISOString]} path:clearRequestsNotificationPath];
//  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    currentUser.numRequestNotification = @0;
//    if ([currentUser.numMessageNotification integerValue] == 0) {
//      currentUser.numNotification = @0;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
//  } failure:[RingUtility operationFailurehandler]];
//    [RingUtility addToOperationToQueue:operation];;
}

+ (void)clearMessagesNotification
{
//  if ([[self all] count] == 0) {
//    return;
//  }
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"updated_at" : [[[[RingNotification all] objectAtIndex:0] createdAt] ISOString]} path:clearMessagesNotificationPath];
//  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    currentUser.numMessageNotification = @0;
//    if ([currentUser.numRequestNotification integerValue] == 0) {
//      currentUser.numNotification = @0;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
//  } failure:[RingUtility operationFailurehandler]];
//    [RingUtility addToOperationToQueue:operation];;
}
@end
