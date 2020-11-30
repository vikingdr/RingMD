//
//  RingBusinessHourPicker.h
//  Ring
//
//  Created by Medpats on 12/25/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

@protocol RingBusinessHourPickerDelegate
- (void)picker:(id)picker dateChanged:(NSDate *)date;
@end

@interface RingBusinessHourPicker : UIPickerView
@property (nonatomic, weak) id<RingBusinessHourPickerDelegate> dateDelegate;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@end
