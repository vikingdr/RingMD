//
//  RingBusinessTimeAdd.m
//  Ring
//
//  Created by Medpats on 1/7/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusinessTimeAdd.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingDatePicker.h"
#import "RingBusinessHourPicker.h"

@interface RingBusinessTimeAdd()<UITableViewDataSource, UITableViewDelegate, RingBusinessHourPickerDelegate> {
  NSInteger _selectedIndex;
}
@property (nonatomic, strong) RingBusinessHourPicker *datePicker;
@end

@implementation RingBusinessTimeAdd
- (RingBusinessHourPicker *)datePicker
{
  if (!_datePicker) {
    _datePicker = [[RingBusinessHourPicker alloc] initWithFrame:PICKER_FRAME];
    _datePicker.dateDelegate = self;
  }
  return _datePicker;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.delegate = self;
    self.dataSource = self;
  }
  return self;
}

- (void)resetTime
{
  self.businessHour = [RingBusinessHour insertWithFrom:[NSDate ringHourParse:@"07:00"] to:[[NSDate date] endOfDay4Part]];
  [self.datePicker reloadAllComponents];
  [self reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _selectedIndex == -1 ? 2 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTimePickerCell:indexPath]) {
    return PICKER_HEIGHT;
  }
  return 44;
}

- (UITableViewCell *)businessTimeCell:(UITableView *)tableView atIndexRow:(NSInteger)row
{
  static NSString *cellIdentify = @"businessTime";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    cell.textLabel.textColor = [UIColor ringOrangeColor];
    cell.textLabel.font = [UIFont ringFontOfSize:14];
  }
  if (row == 0) {
    cell.textLabel.text = @"From";
    cell.detailTextLabel.text = [_businessHour.from hourFormat];
  } else {
    cell.textLabel.text = @"To";
    cell.detailTextLabel.text = [_businessHour.to hourFormat];
  }
  return cell;
}

- (UITableViewCell *)timePickerCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentify = @"timePicker";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  NSInteger row = indexPath.row - 1;
  if (row % 2 == 0) {
    self.datePicker.hour = [_businessHour.from hourValue];
    self.datePicker.minute = [_businessHour.from minuteValue];
  } else {
    self.datePicker.hour = [_businessHour.to hourValue];
    self.datePicker.minute = [_businessHour.to minuteValue];
  }
  self.datePicker.frame = PICKER_FRAME;
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    [cell.contentView addSubview:self.datePicker];
  }
  return cell;
}

- (BOOL)isTimePickerCell:(NSIndexPath *)indexPath
{
  return _selectedIndex != -1 && indexPath.row == _selectedIndex + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTimePickerCell:indexPath]) {
    return [self timePickerCell:tableView
                    atIndexPath:indexPath];
  }
  NSInteger row = indexPath.row;
  if (_selectedIndex != -1 && indexPath.row > _selectedIndex) {
    row = indexPath.row - 1;
  }
  return [self businessTimeCell:tableView atIndexRow:row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTimePickerCell:indexPath]) {
    return;
  }
  if (_selectedIndex != -1) {
    _selectedIndex = -1;
  } else {
    _selectedIndex = indexPath.row;
  }
  [self reloadData];
}

#pragma mark RingDatePicker


- (void)picker:(RingBusinessHourPicker *)picker dateChanged:(NSDate *)date
{
  date = [NSDate ringHourParse:[NSString stringWithFormat:@"%02d:%02d",
                                picker.hour, picker.minute]];
  
  NSDate *from = _businessHour.from;
  NSDate *to = _businessHour.to;
  if (_selectedIndex == 0) {
    from = date;
  } else {
    to = date;
  }
  if ([to compare:from] == NSOrderedAscending){
    [UIViewController showMessage:@"'From' must after 'To'" withTitle:@"Validation"];
    return;
  }
  _businessHour.from = from;
  _businessHour.to = to;
}
@end
