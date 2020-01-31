//
//  TourInputWithUnit.h
//  TourNative
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 TourNative. All rights reserved.
//

@interface RingInputWithUnit : UIView<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSArray *units;
@property (strong, nonatomic) NSDictionary *numberMaps;
@property (nonatomic) NSInteger minimumValue;

- (NSString *)currentUnit;
- (NSNumber *)currentNumber;
- (void)showPickerInView:(UIView *)view;
- (void)refreshPickerView;
- (void)showFirstText:(NSString *)text;
@end
