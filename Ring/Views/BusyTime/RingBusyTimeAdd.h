//
//  RingBusyTimeAdd.h
//  Ring
//
//  Created by Medpats on 1/7/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingBusyHour;

@interface RingBusyTimeAdd : UITableView
@property (nonatomic, strong) RingBusyHour *busyHour;

- (void)resetTime;
@end
