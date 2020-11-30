//
//  RingDatePicker.m
//  Ring
//
//  Created by Medpats on 12/27/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingDatePicker.h"

#import "Ring-Essentials.h"

#define NUM_DATE 400
#define MID_NUM 200

@interface RingDatePicker()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@end

@implementation RingDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.delegate = self;
      self.dataSource = self;
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
  _date = date;
  _hour = [date hourValue];
  _minute = self.isBlockTime ? [date minuteValue] / 15 : [date minuteValue];
  [self selectRow:_hour inComponent:0 animated:NO];
  [self selectRow:_minute inComponent:1 animated:NO];
  if (!self.isHourOnly) {
    NSInteger distance = [[NSDate date] distanceToDate:date];
    [self selectRow:(distance + MID_NUM) inComponent:2 animated:NO];
  }
}

#pragma mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return self.isHourOnly ? 2 : 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  switch (component)
  {
    case 0: return 24;
    case 1: return self.isBlockTime ? 4 : 60;
    case 2: return NUM_DATE;
    default: return -1;
  }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel *myView = [[UILabel alloc] init];
  myView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//  myView.backgroundColor = [UIColor orangeColor];
  myView.font = self.font;
  myView.textAlignment = NSTextAlignmentCenter;
  return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
  if (component != 2) {
    return 30;
  }
  if(IS_IPAD)
    return [RingUtility currentWidth] / 3;
  return 160;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSDate *dateItem;
  switch (component)
  {
    case 0: return [NSString stringWithFormat:@"%d", row];
    case 1: return [NSString stringWithFormat:@"%d", self.isBlockTime ? row * 15 : row];
    case 2:
      dateItem = [[NSDate date] dateByAddingTimeInterval:(row - MID_NUM)*24*60*60];
      if ([[[NSDate date] beginOfDay] compare:[dateItem beginOfDay]] == NSOrderedSame) {
        return @"Today";
      }
      return [dateItem dateOnlyFormat];
    default: return nil;
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  NSDate *dateItem = _date;
  switch (component)
  {
    case 0: _hour = row; break;
    case 1: _minute = self.isBlockTime? row * 15 : row; break;
    case 2: dateItem = [[NSDate date] dateByAddingTimeInterval:(row - MID_NUM)*24*60*60]; break;
  }
  NSString *hourString = self.hour > 9 ? [@(self.hour) stringValue] : [NSString stringWithFormat:@"0%d", self.hour];
  NSString *minuteString = self.minute > 9 ? [@(self.minute) stringValue] : [NSString stringWithFormat:@"0%d", self.minute];
  NSString *timeString = [NSString stringWithFormat:@"%@ %@:%@",[dateItem dateOnlyFormat], hourString, minuteString];
  _date = [NSDate ringShortDateParse:timeString];
  [self.dateDelegate picker:self dateChanged:_date];
}

@end
