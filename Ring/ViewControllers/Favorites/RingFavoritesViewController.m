//
//  RingFavoritesViewController.m
//  Ring
//
//  Created by Medpats on 6/13/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingFavoritesViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingDoctorCell.h"
#import "RingDoctorProfileViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "RingTextCenterCell.h"
#import "RingEmptyCell.h"

#define CELL_ID @"doctorCell"
#define EMPTY_CELL_ID @"EmptyCell"

@interface RingFavoritesViewController ()<RingDoctorCellDelegate, NavigationBarOptions>{
  NSInteger showAddIndex;
}
@property BOOL isLoading;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSArray *doctors;
@end

@implementation RingFavoritesViewController

- (RingUser *)user {
  return [RingUser currentCacheUser];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.doctors = @[];
  [self initTableView];
  [self decorateWhitebackground];
  showAddIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self observeEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.tableView reloadData];
}

- (BOOL)shouldReturnToMenu
{
  return YES;
}

- (void)initTableView
{
  [self.tableView registerNib:[UINib nibWithNibName:[RingDoctorCell nibName] bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self.tableView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellReuseIdentifier:EMPTY_CELL_ID];
  self.tableView.separatorColor = [UIColor ringLightGrayColor];
  
  if (IS_OS_7_OR_LATER) {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  self.isLoading = YES;
  [self.tableView addInfiniteScrollingWithActionHandler:^{
    [self loadNextDataPage];
  }];
  [self loadNextDataPage];
}


- (void)loadNextDataPage
{
  NSInteger favoritesCount = self.doctors.count;
  
  [self.user loadFavoriteDoctorsWithPage:self.currentPage + 1 andSuccess:^{
    self.isLoading = NO;
    
    self.doctors = [self.user.favorites array];
    
    [self.tableView.infiniteScrollingView stopAnimating];
    [self updateUIAfterLoadData];
    
    if(favoritesCount + perPage == self.doctors.count) {
      self.currentPage++;
    } else {
      self.tableView.showsInfiniteScrolling = NO;
    }
  }];
}

- (void)updateUIAfterLoadData
{
  self.tableView.userInteractionEnabled = self.doctors.count != 0;
  [self.tableView reloadData];
}

- (BOOL)isShowEmpty
{
  return !self.isLoading && [self.doctors count] == 0 && self.tableView.infiniteScrollingView.state != SVInfiniteScrollingStateLoading;
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self isShowEmpty]) {
    return 1;
  }
  return [self.doctors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isShowEmpty]) {
    return self.view.frame.size.height;
  }
  return IS_IPAD ? 135 : 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.doctors count] == 0) {
    RingEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPTY_CELL_ID];
    cell.titleEmpty.text =  @"No favorite doctors";
    cell.subTitleEmpty.text = @"Go to a doctor’s profile to save him or her in Favorites";
    cell.imageEmtpyIcon.image = [UIImage imageNamed:@"favorites-empty"];
    return cell;
  }
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
  if ([self.doctors count] == 0) {
    return;
  }
  RingDoctorProfileViewController *doctorDetail = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
  doctorDetail.doctor = self.doctors[indexPath.row];
  [self.navigationController pushViewController:doctorDetail animated:YES];
}

#pragma mark -- RingDoctorCellDelegate
- (void)doctorCellRefreshUser:(RingUser *)user
{
//  showAddIndex = [self.doctors indexOfObject:user];
  [self.tableView reloadData];
}
@end
