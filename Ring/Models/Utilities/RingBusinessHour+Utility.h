//
//  RingBusinesssHour+Utility.h
//  Ring
//
//  Created by Medpats on 12/19/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingBusinessHour.h"

@interface RingBusinessHour (Utility)
+ (NSArray *)insertWithJSONArray:(NSArray *)jsonArray;
+ (RingBusinessHour *)insertWithFrom:(NSDate *)from to:(NSDate *)to;

+ (void)loadBusinessHoursWithSuccess:(void(^)(NSMutableArray *businessHours))successBlock;
+ (void)submitBusinessHour:(NSArray *)businessHours toServerWithSuccess:(void(^)(void))successBlock;
@end
