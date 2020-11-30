//
//  RingTimeSlotInMonthInMonth+Utility.m
//  Ring
//
//  Created by Medpats on 7/3/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingTimeSlotInMonth+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

@implementation RingTimeSlotInMonth (Utility)
+ (RingTimeSlotInMonth *)findById:(NSNumber *)timeSlotInMonthId
{
  return (RingTimeSlotInMonth *)[[RingData sharedInstance] findSingleEntity:@"RingTimeSlotInMonth" withPredicateString:@"timeSlotInMonthId == %@" andArguments:@[timeSlotInMonthId] withSortDescriptionKey:nil];
}

+ (RingTimeSlotInMonth *)insertWithJSON:(NSDictionary *)jsonData
{
  RingTimeSlotInMonth *timeSlotInMonth = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RingTimeSlotInMonth"
                            inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [timeSlotInMonth updateAttributeWithJson:jsonData];
  return timeSlotInMonth;
}

+ (RingTimeSlotInMonth *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingTimeSlotInMonth *timeSlotInMonth = (RingTimeSlotInMonth *)[[RingData sharedInstance] findSingleEntity:@"RingTimeSlotInMonth" withPredicateString:@"timeSlotInMonthId == %@" andArguments:@[[jsonData objectForKey:@"id"]] withSortDescriptionKey:nil];
  if (timeSlotInMonth)
    [timeSlotInMonth updateAttributeWithJson:jsonData];
  else
    timeSlotInMonth = [RingTimeSlotInMonth insertWithJSON:jsonData];
  
  return timeSlotInMonth;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *timeSlotInMonthJson in jsonArray) {
      [results addObject:[RingTimeSlotInMonth insertOrUpdateWithJSON:timeSlotInMonthJson]];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"state": @"aasm_state", @"timeSlotInMonthId" : @"id", @"status" : @"status", @"type" : @"reservable_type"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  self.startTime = [NSDate parse:[jsonData objectForKey:@"start_time"]];
  self.endTime = [NSDate parse:[jsonData objectForKey:@"end_time"]];
}

+ (BOOL)busyInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots
{
  NSPredicate *predicate =   [NSPredicate predicateWithFormat:@"type == %@ AND startTime <= %@ AND endTime >= %@", @"BusyTime", [date beginOfDay], [date endOfDay]];
  NSArray *results = [timeSlots filteredArrayUsingPredicate:predicate];
  return [results count] != 0;
}

+ (NSInteger)numberOfApprovedTimeSlotInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots
{
  NSPredicate *predicate =   [NSPredicate predicateWithFormat:@"(startTime >= %@ AND startTime <= %@ OR endTime >= %@ AND endTime <= %@) AND state == %@ AND status == %@ AND type == %@", [date beginOfDay], [date endOfDay], [date beginOfDay], [date endOfDay], @"enabled", @"accepted", @"TimeSlot"];
  NSArray *results = [timeSlots filteredArrayUsingPredicate:predicate];
  return [results count];
}

+ (NSInteger)numberOfPendingTimeSlotInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots
{
  NSPredicate *predicate =   [NSPredicate predicateWithFormat:@"(startTime >= %@ AND startTime <= %@ OR endTime >= %@ AND endTime <= %@) AND state == %@ AND status <> %@ AND type == %@", [date beginOfDay], [date endOfDay], [date beginOfDay], [date endOfDay], @"enabled", @"accepted", @"TimeSlot"];
  NSArray *results = [timeSlots filteredArrayUsingPredicate:predicate];
  return [results count];
}

+ (void)statusInMonth:(NSDate *)date andSuccess:(void(^)(NSArray *))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"date" : [date dateSubmitServerFormat]} path:busyDateInMonthPath];
  [operation perform:^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } modally:YES];
}
@end
