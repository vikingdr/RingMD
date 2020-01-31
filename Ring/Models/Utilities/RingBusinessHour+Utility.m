//
//  RingBusinesssHour+Utility.m
//  Ring
//
//  Created by Medpats on 12/19/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingBusinessHour+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

@implementation RingBusinessHour (Utility)

+ (RingBusinessHour *)insertWithHourArray:(NSArray *)fromTo
{
  RingBusinessHour *businessHour = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"RingBusinessHour"
                                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  businessHour.from = [NSDate ringHourParse:[fromTo firstObject]];
  businessHour.to =[NSDate ringHourParse:[fromTo lastObject]];
  return businessHour;
}

+ (RingBusinessHour *)insertWithArray:(NSArray *)fromTo
{
  RingBusinessHour *businessHour = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"RingBusinessHour"
                                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  businessHour.from = [NSDate ringBusinessParse:[fromTo firstObject]];
  businessHour.to =[NSDate ringBusinessParse:[fromTo lastObject]];
  return businessHour;
}

+ (RingBusinessHour *)insertWithFrom:(NSDate *)from to:(NSDate *)to
{
  RingBusinessHour *businessHour = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"RingBusinessHour"
                                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  businessHour.from = from;
  businessHour.to = to;
  return businessHour;
}

+ (NSArray *)insertWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSArray *fromTo in jsonArray) {
      NSDate *from = [NSDate ringBusinessParse:[fromTo firstObject]];
      NSDate *to =[NSDate ringBusinessParse:[fromTo lastObject]];
      [results addObject:[RingBusinessHour insertWithFrom:from to:to]];
      
      NSInteger minutes = 7 * 24 * 60;
      [results addObject:[RingBusinessHour insertWithFrom:[from dateInNexMinutes:minutes] to:[to dateInNexMinutes:minutes]]];
      
      [results addObject:[RingBusinessHour insertWithFrom:[from dateInNexMinutes:minutes * 2] to:[to dateInNexMinutes:minutes * 2]]];
      
      [results addObject:[RingBusinessHour insertWithFrom:[from dateInNexMinutes:minutes * 3] to:[to dateInNexMinutes:minutes * 3]]];
      
      [results addObject:[RingBusinessHour insertWithFrom:[from dateInNexMinutes:minutes * 4] to:[to dateInNexMinutes:minutes * 4]]];
    }
  }
  return results;
}

+ (NSMutableArray *)generateBusinessHoursFromJson:(NSDictionary *)json
{
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:7];
  NSArray *weekdays = @[@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday"];
  for (NSInteger i = 0; i < [weekdays count]; ++i) {
    NSString *weekday = [weekdays objectAtIndex:i];
    NSArray *slots = [json objectForKey:weekday];
    
    NSMutableArray *businessSlots = [NSMutableArray array];
    if (![slots isEqual:[NSNull null]]) {
      for (NSInteger j = 0; j < [slots count]; ++j) {
        NSArray *slot = [slots objectAtIndex:j];
        RingBusinessHour *businessHour = [RingBusinessHour insertWithHourArray:slot];
        [businessSlots addObject:businessHour];
      }
    }
    results[i] = businessSlots;
  }
  return results;
}

+ (NSDictionary *)manipulateBusinessBeforeSubmit:(NSArray *)businessHours
{
  NSArray *weekdays = @[@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday"];
  NSMutableArray *days = [NSMutableArray array];
  for (NSInteger i = 0; i < [businessHours count]; ++i) {
    NSArray *slots = [businessHours objectAtIndex:i];
    if ([slots count] == 0) {
      [days addObject:@{@"name":  [weekdays objectAtIndex:i]}];
    } else {
      NSMutableArray *slotParams = [NSMutableArray arrayWithCapacity:[slots count]];
      for (NSInteger j = 0; j < [slots count]; ++j) {
        RingBusinessHour *businessHour = [slots objectAtIndex:j];
        [slotParams addObject:@[[businessHour.from hourWithoutAPFormat], [businessHour.to hourWithoutAPFormat]]];
      }
      [days addObject:@{@"status": @(YES),
                        @"name": [weekdays objectAtIndex:i],
                        @"slots" : slotParams}];
    }
  }
  return @{@"days": days};
}

+ (void)loadBusinessHoursWithSuccess:(void(^)(NSMutableArray *businessHours))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:businessHoursPath];
  [operation perform:^(NSDictionary *json) {
    NSMutableArray *array = [self generateBusinessHoursFromJson:json];
    if (successBlock)
      successBlock(array);
  } modally:YES];
}

+ (void)submitBusinessHour:(NSArray *)businessHours toServerWithSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:[self manipulateBusinessBeforeSubmit:businessHours] path:businessHoursUpdatePath];
  [operation perform:^(id json) {
    if (successBlock)
      successBlock();
  } modally:YES];
}
@end
