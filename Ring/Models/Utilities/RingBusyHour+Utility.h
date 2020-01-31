//
//  RingBusyHour+Utility.h
//  Ring
//
//  Created by Medpats on 12/19/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingBusyHour.h"

@interface RingBusyHour (Utility)
+ (NSMutableArray *)insertWithJSONArray:(NSArray *)jsonArray;
+ (RingBusyHour *)insertFromdate:(NSDate *)from to:(NSDate *)to;
+ (void)loadBusyHoursWithSuccess:(void(^)(void))successBlock;
- (void)submitBusyHourWithSuccess:(void(^)(void))successBlock;
+ (void)deleteBusyHour:(RingBusyHour *)busyHour withSuccess:(void(^)(void))successBlock;
@end
