//
//  RingBusinessTimeAdd.h
//  Ring
//
//  Created by Medpats on 1/7/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingBusinessHour;

@interface RingBusinessTimeAdd : UITableView
@property (nonatomic, strong) RingBusinessHour *businessHour;

- (void)resetTime;
@end
