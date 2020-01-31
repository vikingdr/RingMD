//
//  CDatePickerViewEx.h
//  Ring
//
//  Created by Medpats on 12/6/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthYearPickerDelegate<NSObject>
- (void)changeDate:(NSDate *)date;
@end

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign)  id<MonthYearPickerDelegate> pickerDelegate;

- (void)selectToday;
@end
