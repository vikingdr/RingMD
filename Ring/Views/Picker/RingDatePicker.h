//
//  RingDatePicker.h
//  Ring
//
//  Created by Medpats on 12/27/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

@protocol RingDatePickerDelegate
- (void)picker:(id)picker dateChanged:(NSDate *)date;
@end

@interface RingDatePicker : UIPickerView
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) BOOL isHourOnly;
@property (nonatomic) BOOL isBlockTime;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic, weak) id<RingDatePickerDelegate> dateDelegate;
@end
