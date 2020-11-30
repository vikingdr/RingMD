//
//  RingBusyTimeAdd.m
//  Ring
//
//  Created by Medpats on 1/7/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusyTimeAdd.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingDatePicker.h"

@interface RingBusyTimeAdd()<UITableViewDataSource, UITableViewDelegate> {
  NSInteger _selectedIndex;
}
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation RingBusyTimeAdd

- (UIDatePicker *)datePicker
{
  if (!_datePicker) {
    _datePicker = [[UIDatePicker alloc] initWithFrame:PICKER_FRAME];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
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
  self.busyHour = [RingBusyHour insertFromdate:[NSDate today8AM] to:[[NSDate date] endOfDay4Part]];;
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

- (UITableViewCell *)busyTimeCell:(UITableView *)tableView atIndexRow:(NSInteger)row
{
  static NSString *cellIdentify = @"busyTime";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    cell.textLabel.textColor = [UIColor ringOrangeColor];
    cell.textLabel.font = [UIFont ringFontOfSize:14];
  }
  if (row == 0) {
    cell.textLabel.text = @"From";
    cell.detailTextLabel.text = [_busyHour.from shortDisplayFormat];
  } else {
    cell.textLabel.text = @"To";
    cell.detailTextLabel.text = [_busyHour.to shortDisplayFormat];
  }
  return cell;
}

- (UITableViewCell *)timePickerCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentify = @"timePicker";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  NSInteger row = indexPath.row - 1;
  if (row % 2 == 0) {
    self.datePicker.date = _busyHour.from;
  } else {
    self.datePicker.date = _busyHour.to;
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
  return [self busyTimeCell:tableView atIndexRow:row];
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
- (void)dateChanged:(UIDatePicker *)picker
{
  NSDate *from = _busyHour.from;
  NSDate *to = _busyHour.to;
  if (_selectedIndex == 0) {
    from = picker.date;
  } else {
    to = picker.date;
  }
  if ([to compare:from] == NSOrderedAscending){
    [UIViewController showMessage:@"'From' must after 'To'" withTitle:@"Validation"];
    return;
  }
  _busyHour.from = from;
  _busyHour.to = to;
}
@end
