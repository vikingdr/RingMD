//
//  RingCallsViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/10/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingCallsViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingCallRequestDetailsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "RingRequestCell.h"
#import "RingOpenTokViewController.h"
#import "RingEmptyCell.h"

#define CELL_ID @"RequestCell"
#define EMPTY_CELL_ID @"EmptyCell"

@interface RingCallsViewController ()<UITableViewDataSource, UITableViewDelegate, NavigationBarOptions>
@property BOOL isLoading;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilter;
@property (weak, nonatomic) IBOutlet UITableView *callTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffsetHeight;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) NSArray *callRequests;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) RingCallRequest *callNowRequest;
@end

@implementation RingCallsViewController
- (NSArray *)callRequests
{
  if (!_callRequests) {
    _callRequests = @[];
  }
  return _callRequests;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (IS_OS_7_OR_LATER) {
    [self.callTableView setSeparatorInset:UIEdgeInsetsZero];
  }
  self.title = @"Appointments";
  [self decorateWhitebackground];
  [self initTableView];
  [self decorateUIs];
  [self configureExtraWidgets];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self observeEvents];
  [RingNotification clearRequestsNotification];
  [self configureExtraWidgets];
  [self refreshTable];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (BOOL)shouldReturnToMenu
{
  return YES;
}

- (void)decorateUIs
{
  self.segmentFilter.tintColor = [UIColor ringMainColor];
  self.callButton.backgroundColor = [UIColor ringOrangeColor];
  self.callButton.titleLabel.font = [UIFont boldRingFontOfSize:14];
  [self.callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.callButton decorateEclipseWithRadius:3];
}

- (IBAction)segmentFilterChanged:(id)sender {
  self.callTableView.showsInfiniteScrolling = NO;
  [self refreshData];
}

- (void)refreshData
{
  self.isLoading = YES;
  self.currentPage = 0;
  self.callRequests = nil;
//  [self.callTableView reloadData];
  [self loadNextDataPage];
}

- (void)initTableView
{
  self.isLoading = YES;
  
  [self.callTableView registerNib:[UINib nibWithNibName:[RingRequestCell nibName] bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self.callTableView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellReuseIdentifier:EMPTY_CELL_ID];
  self.currentPage = 0;
  self.callTableView.backgroundColor = [UIColor ringWhiteColor];
  [self.callTableView addInfiniteScrollingWithActionHandler:^{
    [self loadNextDataPage];
  }];
  [self loadNextDataPage];
}

- (void)loadNextDataPage
{
  static u_int32_t ident;
  ident = arc4random();
  u_int32_t thisIdent = ident;
  
  NSInteger requestCount = _callRequests.count;
  
  void (^manipulateRequest)(NSArray * results) = ^(NSArray *results){
    if(ident != thisIdent) {
      NSLog(@"Switched segments while results were being loaded");
      return;
    }
    
    self.isLoading = NO;
    
    NSMutableArray *callRequests;
    if (self.currentPage == 0) {
      callRequests = [@[] mutableCopy];
    } else {
      callRequests = [self.callRequests mutableCopy];
    }
    [callRequests addObjectsFromArray:results];
    _callRequests = callRequests;
    
    [self configureExtraWidgets];
    [self.callTableView.infiniteScrollingView stopAnimating];
    [self.callTableView reloadData];
    
    if(requestCount + perPage == _callRequests.count) {
      self.currentPage++;
      self.callTableView.showsInfiniteScrolling = YES;
    } else {
      self.callTableView.showsInfiniteScrolling = NO;
    }
  };
  if (self.segmentFilter.selectedSegmentIndex == 0) {
    [RingCallRequest loadActiveCallRequestsWithPage:self.currentPage + 1 andSuccess:manipulateRequest blockView:self.currentPage == 0 ? self.callTableView : nil];
  } else {
    [RingCallRequest loadHistoryCallRequestsWithPage:self.currentPage + 1 andSuccess:manipulateRequest blockView:self.currentPage == 0 ? self.callTableView : nil];
  }
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:ME_requestRemoved object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCallDetail:) name:CE_gotoCallDetail object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:ME_requestUpdated object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:CE_onlinechanged object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.callTableView reloadData];
}


- (void)refreshTable
{
  [self configureExtraWidgets];
  [self.callTableView reloadData];
}

- (void)gotoCallDetail:(NSNotification *)notification
{
  RingCallRequest *callRequest = [RingCallRequest insertOrUpdateWithJSON:@{@"id" : notification.object}];
  RingCallRequestDetailsViewController *callRequestView = (RingCallRequestDetailsViewController *)[RingUtility getViewControllerWithName:@"callRequest"];
  callRequestView.callRequest = callRequest;
  [self.navigationController pushViewController:callRequestView animated:NO];
}

- (BOOL)isShowEmpty
{
  return !self.isLoading && [self.callRequests count] == 0 && self.callTableView.infiniteScrollingView.state != SVInfiniteScrollingStateLoading;
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isShowEmpty]) {
    return self.view.frame.size.height;
  }
  return IS_IPAD ? 135 : 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self isShowEmpty]) {
    return 1;
  }
  return [self.callRequests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.callRequests count] == 0) {
    RingEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPTY_CELL_ID];
    cell.titleEmpty.text =  @"No appointments scheduled";
    cell.subTitleEmpty.text = @"Go to a doctor’s profile to schedule an appointment";
    cell.imageEmtpyIcon.image = [UIImage imageNamed:@"requests-empty"];
    return cell;
  }
  RingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  cell.request = [self.callRequests objectAtIndex:indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.001f;
}

#pragma mark TableViewDataSourceDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isShowEmpty]) {
    return;
  }
  if ([self.callRequests count] == 0) {
    return;
  }
  RingCallRequestDetailsViewController *callRequestDetail = (RingCallRequestDetailsViewController *)[RingUtility getViewControllerWithName:@"callRequest"];
  callRequestDetail.callRequest = [self.callRequests objectAtIndex:indexPath.row];
  [self.navigationController pushViewController:callRequestDetail animated:YES];
}

- (void)configureExtraWidgets
{
  self.callTableView.userInteractionEnabled = [self.callRequests count] != 0;
  
  self.callNowRequest = [[RingUser currentCacheUser] callNowRequest];
  if (self.callNowRequest) {
    self.topOffsetHeight.constant = 50;
    self.callButton.hidden = NO;
    NSString *title = [NSString stringWithFormat:@"Start Call with %@", self.callNowRequest.user.name];
    [self.callButton setTitle:title forState:UIControlStateNormal];
  } else {
    self.topOffsetHeight.constant = 0;
    self.callButton.hidden = YES;
  }
}

- (IBAction)callButtonPressed:(id)sender {
  RingOpenTokViewController *openTok = (RingOpenTokViewController *)[RingUtility getViewControllerWithName:@"openTokVideoCall"];
  openTok.callRequest = [RingCallRequest findById:self.callNowRequest.callRequestId];
  [self.navigationController pushViewController:openTok animated:YES];
}
@end
