//
//  RingOpenTokSession+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/13/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingOpenTokSession.h"

@interface RingOpenTokSession (Utility)
+ (RingOpenTokSession *)insertWithJSON:(NSDictionary *)jsonData;
+ (RingOpenTokSession *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
@end
