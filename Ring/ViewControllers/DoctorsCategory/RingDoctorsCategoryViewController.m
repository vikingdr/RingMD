//
//  RingDoctorsCategoryViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/6/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingDoctorsCategoryViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "RingDoctorCell.h"
#import "RingDoctorProfileViewController.h"
#import "RingEmptyCell.h"
#import "RingSearchViewController.h"

#define CELL_ID @"doctorCell"
#define EMPTY_CELL_ID @"EmptyCell"

//
// This screen is used both for the overview of featured doctors (the first screen loaded)
// and for search results when a specialty is tapped in the search screen.
//

@interface RingDoctorsCategoryViewController () <RingDoctorCellDelegate, NavigationBarOptions> {
  NSMutableArray *_featuredDoctors;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RingDoctorsCategoryViewController

- (NSArray *)doctors
{
  return self.speciality ? [self.speciality.doctors array] : [RingUser featuredDoctors];
}

- (void)viewDidLoad
{
  assert(currentUser);
  [super viewDidLoad];
  [self initTableView];
  self.tableView.backgroundColor = self.view.backgroundColor;
  [self decorateWhitebackground];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self observeEvents];
  self.title = self.speciality ? self.speciality.name : @"Doctors" ;
  
  if (!self.speciality) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchView)];
  }
  
  [self.tableView addInfiniteScrollingWithActionHandler:^{
    [self loadNextDataPage];
  }];
  
  if([self.tableView numberOfRowsInSection:0] == 0) {
    [self loadNextDataPage];
  }
}

- (void)loadNextDataPage
{
  NSInteger pageNumber = floor(self.doctors.count / perPage) + 1;
  
  void (^successBlock)(NSArray *) = ^(NSArray *newDoctors) {
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView stopAnimating];
    if(newDoctors.count < perPage) {
      self.tableView.showsInfiniteScrolling = NO;
    }
  };
  
  if(self.speciality) {
    [self.speciality loadSpecialistsWithSuccessBlock:successBlock
                                                page:pageNumber];
  } else {
    [RingUser featuredDoctorsWithSuccess:successBlock page:pageNumber];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (BOOL)shouldReturnToMenu
{
  return !self.speciality;
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextNotification:) name:CE_searchText object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:CE_onlinechanged object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.tableView reloadData];
}

- (void)initTableView
{
  [self.tableView registerNib:[UINib nibWithNibName:[RingDoctorCell nibName] bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self.tableView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellReuseIdentifier:EMPTY_CELL_ID];
  self.tableView.separatorColor = [UIColor ringLightGrayColor];
  
  if (IS_OS_7_OR_LATER) {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  }
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.doctors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return IS_IPAD ? 135 : 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  cell.user = [self.doctors objectAtIndex:indexPath.row];
  cell.delegate = self;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.001f;
}

#pragma mark --TableViewDataSourceDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingDoctorProfileViewController *doctorDetail = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
  doctorDetail.doctor = self.doctors[indexPath.row];
  [self.navigationController pushViewController:doctorDetail animated:YES];
}

- (void)doctorCellRefreshUser:(RingUser *)user
{
  [self.tableView reloadData];
}

- (void)showSearchView
{
  RingSearchViewController *searchView = (RingSearchViewController *)[RingUtility getViewControllerWithName:@"searchView"];
  [self.navigationController pushViewController:searchView animated:YES];
}
@end
