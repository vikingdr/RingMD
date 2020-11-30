//
//  RingBusinessHourPicker.m
//  Ring
//
//  Created by Medpats on 12/25/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingBusinessHourPicker.h"

#import "Ring-Essentials.h"

@interface RingBusinessHourPicker()<UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation RingBusinessHourPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.delegate = self;
      self.dataSource = self;
    }
    return self;
}

- (void)setHour:(NSInteger)hour
{
  _hour = hour;
  [self selectRow:hour inComponent:0 animated:YES];
}

- (void)setMinute:(NSInteger)minute
{
  _minute = minute;
  [self selectRow:minute/15 inComponent:1 animated:YES];
}

#pragma mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  switch (component)
  {
    case 0: return 24;
    case 1: return 4;
    default: return -1;
  }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel *myView = [[UILabel alloc] init];
  myView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  myView.backgroundColor = [UIColor orangeColor];
  myView.textAlignment = NSTextAlignmentCenter;
  return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
  if(IS_IPAD)
    return [RingUtility currentWidth] / 3;
  return 106;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  switch (component)
  {
    case 0: return [NSString stringWithFormat:@"%d", row];
    case 1: return [NSString stringWithFormat:@"%d", row * 15];
    default: return nil;
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  switch (component)
  {
    case 0: _hour = row; break;
    case 1: _minute = row * 15; break;
  }
  NSString *hourString = self.hour > 9 ? [@(self.hour) stringValue] : [NSString stringWithFormat:@"0%d", self.hour];
  NSString *minuteString = self.minute > 9 ? [@(self.minute) stringValue] : [NSString stringWithFormat:@"0%d", self.minute];
  NSString *timeString = [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
  NSDate *date = [NSDate ringHourParse:timeString];
  [self.dateDelegate picker:self dateChanged:date];
  
}
@end
