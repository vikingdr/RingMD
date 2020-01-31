//
//  RingBusinessTimeAdd.h
//  Ring
//
//  Created by Medpats on 1/7/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingBusinessHour;

@interface RingBusinessTimeAdd : UITableView
@property (nonatomic, strong) RingBusinessHour *businessHour;

- (void)resetTime;
@end
