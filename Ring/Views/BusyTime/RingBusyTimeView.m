//
//  RingBusyEditting.m
//  Ring
//
//  Created by Medpats on 12/24/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingBusyTimeView.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingBusyTimeCell.h"
#import "RingTextCenterCell.h"

#define CELL_ID @"busyTime"
#define EMPTY_CELL_ID @"emptycell"
#define CELL_HEIGHT 55

@interface RingBusyTimeView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@end

@implementation RingBusyTimeView
@synthesize busyHours = _busyHours;
- (void)updateNecesseryStuff
{
  self.delegate = self;
  self.dataSource = self;
  [self initTableView];
  self.backgroundColor = [UIColor ringWhiteColor];
  [self setEditting:NO];
}

- (void)setBusyHours:(NSMutableArray *)busyHours
{
  _busyHours = busyHours;
  [self reloadData];
}

- (NSMutableArray *)busyHours
{
  if (!_busyHours) {
    _busyHours = [NSMutableArray array];
  }
  return _busyHours;
}

- (void)setEditting:(BOOL)editting
{
  _editting = editting;
  [self setEditing:editting animated:YES];
}

- (void)addBusyTime:(RingBusyHour *)busyHour
{
  [busyHour submitBusyHourWithSuccess:^{
    [self.busyHours addObject:busyHour];
    [self reloadData];
  }];
}

- (void)initTableView
{
  self.separatorInset = UIEdgeInsetsZero;
  [self registerNib:[UINib nibWithNibName:@"RingBusyTimeCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self registerClass:[RingTextCenterCell class] forCellReuseIdentifier:EMPTY_CELL_ID];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self.busyHours count] == 0) {
    return 1;
  }
  return [self.busyHours count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.busyHours count] == 0) {
    return self.frame.size.height;
  }
  return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

- (UITableViewCell *)busyTimeCell:(UITableView *)tableView atIndexRow:(NSInteger)row
{
  RingBusyTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  RingBusyHour *busyHour = [self.busyHours objectAtIndex:row];
  cell.busyHour = busyHour;
  cell.backgroundColor = [UIColor ringWhiteColor];
  return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.busyHours count] == 0) {
    RingTextCenterCell *cell = [[RingTextCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EMPTY_CELL_ID];
    cell.textLabel.text = @"NO BUSY TIME SET";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor ringWhiteColor];
    return cell;
  }
  return [self busyTimeCell:tableView atIndexRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.busyHours count] != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    RingBusyHour *busyHour = [self.busyHours objectAtIndex:indexPath.row];
    [RingBusyHour deleteBusyHour:busyHour withSuccess:^{
      self.busyHours = [[[RingUser currentCacheUser].busyHours allObjects] mutableCopy];
      [self reloadData];
    }];
  }
}
@end
