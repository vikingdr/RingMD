//
//  RingBusyEditting.h
//  Ring
//
//  Created by Medpats on 12/24/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

@class RingBusyHour;

@interface RingBusyTimeView : UITableView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *busyHours;
@property (nonatomic, assign) BOOL editting;

- (void)addBusyTime:(RingBusyHour *)busyHour;
- (void)updateNecesseryStuff;
@end
