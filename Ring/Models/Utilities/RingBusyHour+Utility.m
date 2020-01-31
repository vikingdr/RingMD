//
//  RingBusyHour+Utility.m
//  Ring
//
//  Created by Medpats on 12/19/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingBusyHour+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingBusyHour (Utility)

+ (RingBusyHour *)insertWithJSON:(NSDictionary *)fromTo
{
  RingBusyHour *busyHour = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RingBusyHour"
                            inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  [busyHour updateAttributeWithJson:fromTo];
  return busyHour;
}

+ (RingBusyHour *)insertFromdate:(NSDate *)from to:(NSDate *)to
{
  RingBusyHour *busyHour = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RingBusyHour"
                            inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  busyHour.from = from;
  busyHour.to = to;
  return busyHour;
}


+ (NSMutableArray *)insertWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *busyHour in jsonArray) {
      [results addObject:[RingBusyHour insertWithJSON:busyHour]];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  if ([jsonData objectForKey:@"id"]) {
    self.busyHourId = [jsonData objectForKey:@"id"];
  }
  self.from = [NSDate parse:[jsonData objectForKey:@"start_time"]];
  self.to = [NSDate parse:[jsonData objectForKey:@"end_time"]];
}

+ (void)loadBusyHoursWithSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:busyHourPath];
  [operation perform:^(NSArray *json) {
    [RingUser currentCacheUser].busyHours = [[NSSet alloc] initWithArray:[self insertWithJSONArray:json]];
    if (successBlock)
      successBlock();
  } modally:YES];
}

- (void)submitBusyHourWithSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"start_time": [self.from sumbitServerFormat], @"end_time": [self.to sumbitServerFormat]} path:busyHourPath];
  [operation perform:^(NSDictionary *json) {
    if ([json objectForKey:@"id"]) {
      self.busyHourId = [json objectForKey:@"id"];
      self.user = [RingUser currentCacheUser];
      if (successBlock)
        successBlock();
    } else {
      [UIViewController showMessage:@"Unknown error." withTitle:@"Form Data Invalid"];
    }
  } modally:YES];
}

+ (void)deleteBusyHour:(RingBusyHour *)busyHour withSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"DELETE" params:@{} path:[NSString stringWithFormat:busyHourDeletePath, busyHour.busyHourId]];
  [operation perform:^(id json) {
    [[RingData sharedInstance] deleteObjects:@[busyHour]];
    if (successBlock)
      successBlock();
  } modally:YES];
}
@end
