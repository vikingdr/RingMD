//
//  RingMedialHistory.m
//  Ring
//
//  Created by Medpats on 8/19/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingMedialHistory.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingExtraPatientQuestion.h"
#import "RingQuestionCell.h"

#define CELL_ID @"HistoryQuestion"

@interface RingMedialHistory()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSArray *groupTypes;
@end

@implementation RingMedialHistory
- (NSArray *)groups
{
  if (!_groups) {
    _groups = @[@"Family History", @"Past History", @"Social History", @"Current Medication"];
  }
  return _groups;
}

- (NSArray *)groupTypes
{
  if (!_groupTypes) {
    _groupTypes = @[@"FamilyPatientQuestion", @"PastPatientQuestion", @"SocialPatientQuestion", @"CurrentPatientQuestion"];
  }
  return _groupTypes;
}

- (void)awakeFromNib
{
  [self initTableView];
}


- (void)initTableView
{
  self.delegate = self;
  self.dataSource = self;
  [self registerNib:[UINib nibWithNibName:[RingQuestionCell nibName] bundle:nil] forCellReuseIdentifier:CELL_ID];
  self.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  NSLog(@"Should also call [[RingUser currentCacheUser] getFullUserInfoWithSuccess:^{}]");
  [RingPatientQuestion loadAllSuccess:^{
    [self reloadData];
  }];
}

- (NSArray *)questionAtSection:(NSInteger)section
{
  return [RingPatientQuestion getByType:self.groupTypes[section]];
}

- (RingPatientQuestion *)patientQuestionAtIndexPath:(NSIndexPath *)indexPath
{
  return [[self questionAtSection:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark --UITableViewDelegate
- (NSInteger)generateIndexForIndexPath:(NSIndexPath *)indexPath
{
  return indexPath.section * 100 + indexPath.row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self questionAtSection:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return  IS_IPAD ? 65.0f : 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return self.groups[section];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.text = [NSString stringWithFormat:@"   %@",[self tableView:tableView titleForHeaderInSection:section]];
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
  titleLabel.backgroundColor = [UIColor colorWithRed:0.953 green:0.969 blue:0.969 alpha:1];
  [titleLabel decorateBorder:0.5 andColor:[UIColor colorWithRed:0.816 green:0.824 blue:0.827 alpha:1]];
  return titleLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.index = [self generateIndexForIndexPath:indexPath];
  cell.user = self.user;
  cell.patientQuestion = [self patientQuestionAtIndexPath:indexPath];
  cell.delegate = self.questionCellDelegate;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[[self patientQuestionAtIndexPath:indexPath] extraQuestion].type isEqualToString:@"text_area"]) {
    return CELL_TEXTAREA_HEIGHT;
  }
  return [RingQuestionCell heightForCellWithUser:self.user question:[self patientQuestionAtIndexPath:indexPath]];
}
@end
