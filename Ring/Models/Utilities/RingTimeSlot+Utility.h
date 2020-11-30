//
//  RingTimeSlot+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/11/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingTimeSlot.h"

@interface RingTimeSlot (Utility)
+ (RingTimeSlot *)findById:(NSNumber *)timeSlotId;
+ (RingTimeSlot *)insertWithTime:(NSDate *)date;
+ (RingTimeSlot *)insertWithTimeString:(NSString *)timeString;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
+ (NSArray *)insertWithJSONArray:(NSArray *)jsonArray;

- (BOOL)isAccepted;
- (BOOL)canJoinNow;
- (NSString *)suggestedName;

- (void)approveTimeslotWithSuccess:(void(^)(void))success;
@end
