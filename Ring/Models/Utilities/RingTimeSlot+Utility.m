//
//  RingTimeSlot+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/11/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingTimeSlot+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingTimeSlot (Utility)
+ (RingTimeSlot *)insertWithTimeString:(NSString *)timeString
{
  RingTimeSlot *timeSlot = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"RingTimeSlot"
                                  inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  timeSlot.callTime = [NSDate parse:timeString];
  return timeSlot;
}

+ (RingTimeSlot *)insertWithTime:(NSDate *)date
{
  RingTimeSlot *timeSlot = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RingTimeSlot"
                            inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  timeSlot.callTime = date;
  return timeSlot;
}

+ (RingTimeSlot *)findById:(NSNumber *)timeSlotId
{
  return (RingTimeSlot *)[[RingData sharedInstance] findSingleEntity:@"RingTimeSlot" withPredicateString:@"timeSlotId == %@" andArguments:@[timeSlotId] withSortDescriptionKey:nil];
}

+ (RingTimeSlot *)insertWithJSON:(NSDictionary *)jsonData
{
  RingTimeSlot *timeSlot = [NSEntityDescription
                    insertNewObjectForEntityForName:@"RingTimeSlot"
                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [timeSlot updateAttributeWithJson:jsonData];
  return timeSlot;
}

+ (RingTimeSlot *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingTimeSlot *timeSlot = (RingTimeSlot *)[[RingData sharedInstance] findSingleEntity:@"RingTimeSlot" withPredicateString:@"timeSlotId == %@" andArguments:@[[jsonData objectForKey:@"id"]] withSortDescriptionKey:nil];
  if (timeSlot)
    [timeSlot updateAttributeWithJson:jsonData];
  else
    timeSlot = [RingTimeSlot insertWithJSON:jsonData];
  
  return timeSlot;
}

+ (NSArray *)insertWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *timeSlotJson in jsonArray) {
      [results addObject:[RingTimeSlot insertWithTime:[NSDate parse:[timeSlotJson objectForKey:@"start_time"]]]];
    }
  }
  return results;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *timeSlotJson in jsonArray) {
      [results addObject:[RingTimeSlot insertOrUpdateWithJSON:timeSlotJson]];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"state": @"state", @"timeSlotId" : @"id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  self.callTime = [NSDate parse:[jsonData objectForKey:@"call_time"]];
}

- (BOOL)canJoinNow
{
  return ![self.callRequest isNormalCall] && [self isAccepted];
}

- (BOOL)isAccepted
{
  return [self.state isEqualToString:@"accepted"] && [self.callRequest isAccepted];
}

- (NSString *)suggestedName
{
  if ([self isAccepted]) {
    if (!IS_DOCTOR) {
      return self.callRequest.user.name;
    }
  } else {
    if (IS_DOCTOR) {
      return self.callRequest.user.name;
    }
  }
  return @"You";
}

- (void)approveTimeslotWithSuccess:(void(^)(void))success
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"time_slot_id" : self.timeSlotId} path:[NSString stringWithFormat:approveTimeslotPath, self.callRequest.callRequestId]];
  [operation perform:^(id json) {
    self.state = @"accepted";
    self.callRequest.callTime = self.callTime;
    self.callRequest.state = @"accepted";
    success();
  } modally:YES];
}

@end
