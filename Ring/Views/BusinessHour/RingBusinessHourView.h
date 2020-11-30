//
//  RingBusinessEditting.h
//  Ring
//
//  Created by Medpats on 12/24/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

@class RingBusinessHour;

@protocol RingBusinessHourDelegate
- (void)businessHourEditted;
@end

@interface RingBusinessHourView : UITableView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *businessHours;
@property (nonatomic, assign) BOOL editting;
@property (nonatomic, weak) id<RingBusinessHourDelegate> businessHourDelegate;

- (void)addBusinessHour:(RingBusinessHour *)businessHour;
- (void)updateNecesseryStuff;
@end
