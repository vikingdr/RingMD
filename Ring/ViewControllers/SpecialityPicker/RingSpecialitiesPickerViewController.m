//
//  RingSpecialitiesPickerViewController.m
//  Ring
//
//  Created by Medpats on 7/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingSpecialitiesPickerViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#define HEADER_HEIGHT 44

@interface RingSpecialitiesPickerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *parentSpecialities;
@end

@implementation RingSpecialitiesPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
  self.navigationController.navigationBarHidden = YES;
}

- (void)loadData
{
  [RingSpeciality pullSpecialitiesWithSuccess:^(NSArray *countries) {
    _parentSpecialities = [RingSpeciality allParents];
    [self.tableView reloadData];
  }];
}

#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [RingUtility currentWidth], HEADER_HEIGHT)];
  view.text = [NSString stringWithFormat:@"   %@", [self.parentSpecialities[section] name]];
  view.backgroundColor = [UIColor ringWhiteColor];
  view.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  view.textColor = [UIColor ringMainColor];
  view.tag = section;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
  [view addGestureRecognizer:tap];
  view.userInteractionEnabled = YES;
  return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.parentSpecialities count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self.parentSpecialities[section] children] count];
}

- (RingSpeciality *)specialityAtIndexPath:(NSIndexPath *)indexPath
{
  return [[self.parentSpecialities[indexPath.section] children] array][indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identify = @"spec1";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont ringFontOfSize:14];
  }
  RingSpeciality *speciality = [self specialityAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"   %@", [speciality name]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingSpeciality *speciality = [self specialityAtIndexPath:indexPath];
  [self.delegate RingSpecialitySelected:speciality];
  [self dismissPopup:tableView];
}

- (void)headerTapped:(UITapGestureRecognizer *)gesture
{
  NSInteger index = gesture.view.tag;
  RingSpeciality *speciality = self.parentSpecialities[index];
  if ([speciality.children count] == 0) {
    [self.delegate RingSpecialitySelected:speciality];
    [self dismissPopup:gesture];
  }
}
@end
