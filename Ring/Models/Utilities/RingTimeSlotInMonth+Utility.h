//
//  RingTimeSlotInMonth+Utility.h
//  Ring
//
//  Created by Medpats on 7/3/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingTimeSlotInMonth.h"

@interface RingTimeSlotInMonth (Utility)
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;

+ (NSInteger)numberOfPendingTimeSlotInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots;
+ (NSInteger)numberOfApprovedTimeSlotInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots;
+ (BOOL)busyInDate:(NSDate *)date inTimeSlots:(NSArray *)timeSlots;

+ (void)statusInMonth:(NSDate *)date andSuccess:(void(^)(NSArray *))successBlock;
@end
