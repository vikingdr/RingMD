//
//  RingBusinessEditting.m
//  Ring
//
//  Created by Medpats on 12/24/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingBusinessHourView.h"

#import "Ring-Essentials.h"

#import "RingBusinessHourPicker.h"
#import "RingBusinessTimeCell.h"
#import "RingTextCenterCell.h"

#define CELL_ID @"businessTime"
#define EMPTY_CELL_ID @"emptycell"
#define CELL_HEIGHT 55

@interface RingBusinessHourView()<UITableViewDataSource, UITableViewDelegate, RingBusinessHourPickerDelegate>

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@end

@implementation RingBusinessHourView
@synthesize businessHours = _businessHours;
- (void)updateNecesseryStuff
{
  self.delegate = self;
  self.dataSource = self;
  [self initTableView];
  self.backgroundColor = [UIColor ringWhiteColor];
  [self setEditting:NO];
}

- (void)setBusinessHours:(NSMutableArray *)businessHours
{
  _businessHours = businessHours;
  [self reloadData];
}

- (NSMutableArray *)businessHours
{
  if (!_businessHours) {
    _businessHours = [NSMutableArray array];
  }
  return _businessHours;
}

- (void)setEditting:(BOOL)editting
{
  _editting = editting;
  [self setEditing:editting animated:YES];
}

- (void)addBusinessHour:(RingBusinessHour *)businessHour
{
  [self.businessHours addObject:businessHour];
  [self reloadData];
  [self.businessHourDelegate businessHourEditted];
}

- (void)initTableView
{
  self.separatorInset = UIEdgeInsetsZero;
  [self registerNib:[UINib nibWithNibName:@"RingBusinessTimeCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self registerClass:[RingTextCenterCell class] forCellReuseIdentifier:EMPTY_CELL_ID];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self.businessHours count] == 0) {
    return 1;
  }
  return [self.businessHours count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.businessHours count] == 0) {
    return self.frame.size.height;
  }
  return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

- (UITableViewCell *)businessTimeCell:(UITableView *)tableView atIndexRow:(NSInteger)row
{
  RingBusinessTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  RingBusinessHour *businessHour = [self.businessHours objectAtIndex:row];
  cell.businessHour = businessHour;
  cell.backgroundColor = [UIColor ringWhiteColor];
  return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.businessHours count] == 0) {
    RingTextCenterCell *cell = [[RingTextCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EMPTY_CELL_ID];
    cell.textLabel.text = @"DON'T WORK ALL DAY";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor ringWhiteColor];
    return cell;
  }
  return [self businessTimeCell:tableView atIndexRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.businessHours count] != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.businessHours removeObjectAtIndex:indexPath.row];
    [self reloadData];
    [self.businessHourDelegate businessHourEditted];
  }
}

#pragma mark PICKER
- (void)picker:(id)picker dateChanged:(NSDate *)date
{
  [self reloadData];
  [self.businessHourDelegate businessHourEditted];
}
@end
