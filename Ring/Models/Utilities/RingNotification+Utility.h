//
//  RingNotification+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/19/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingNotification.h"

#define MESSAGE_TYPE @"Message"
#define REVIEW_TYPE @"Review"
#define CALL_REQUEST_TYPE @"CallRequest"
#define VIDEO_REQUEST_TYPE @"VideoRequest"

@interface RingNotification (Utility)
+ (NSArray *)all;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
+ (RingNotification *)insertWithJSON:(NSDictionary *)jsonData;

//Submit Server
+ (void)clearRequestsNotification;
+ (void)clearMessagesNotification;
@end
