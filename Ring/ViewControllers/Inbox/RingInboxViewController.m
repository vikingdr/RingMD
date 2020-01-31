//
//  RingInboxViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/18/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingInboxViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import "RingMessagesViewController.h"
#import "RingInboxCell.h"
#import "RingConversation+Utility.h"
#import "RingEmptyCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define CELL_ID @"InboxCell"
#define EMPTY_CELL_ID @"EmptyCell"

@interface RingInboxViewController ()<UITableViewDelegate, UITableViewDataSource, NavigationBarOptions> {
  NSInteger _currentPage;
}
@property BOOL isLoading;
@property (weak, nonatomic) IBOutlet UITableView *inboxTableView;
@property (strong, nonatomic) NSArray *conversations;
@end

@implementation RingInboxViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (IS_OS_7_OR_LATER) {
    [self.inboxTableView setSeparatorInset:UIEdgeInsetsZero];
  }
  [self decorateWhitebackground];
  self.title = @"Inbox";
  [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self observeEvents];
  [self observeModelEvents];
  [RingNotification clearMessagesNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveModelEvents];
  [self unObserveEvents];
}

- (void)initTableView
{
  [self.inboxTableView registerNib:[UINib nibWithNibName:[RingInboxCell nibName] bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self.inboxTableView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellReuseIdentifier:EMPTY_CELL_ID];
  self.inboxTableView.separatorColor = [UIColor ringLightGrayColor];
  
  self.isLoading = YES;
  [self.inboxTableView addInfiniteScrollingWithActionHandler:^{
    [self loadNextPage];
  }];
  [self loadNextPage];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCallDetail:) name:CE_gotoMessageDetail object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotoCallDetail:(NSNotification *)notification
{
  RingUser *user = [RingUser insertOrUpdateWithJSON:@{@"user_id" : notification.object}];
  RingMessagesViewController *messageView = (RingMessagesViewController *)[RingUtility getViewControllerWithName:@"messages"];
  messageView.user = user;
  [self.navigationController pushViewController:messageView animated:NO];
}

- (void)loadNextPage
{
  [self loadData:_currentPage + 1];
}

- (void)loadData:(NSInteger)pageNumber
{
  NSInteger inboxSize = self.conversations.count;
  
  [RingConversation loadInboxWithPage:pageNumber success:^{
    self.isLoading = NO;
    
    self.conversations = [RingConversation inbox];
    
    [self.inboxTableView.infiniteScrollingView stopAnimating];
    [self.inboxTableView reloadData];
    
    if(inboxSize + perPage == self.conversations.count) {
      _currentPage++;
    } else {
      self.inboxTableView.showsInfiniteScrolling = NO;
    }
  }];
}

- (void)reloadFirstPage
{
  [self loadData:1];
}

- (void)observeModelEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotification:) name:ME_messageUpdated object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:CE_onlinechanged object:nil];
}

- (void)unObserveModelEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userNotification:(NSNotification *)notification
{
  [self reloadFirstPage];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.inboxTableView reloadData];
}

- (BOOL)shouldReturnToMenu
{
  return YES;
}

- (BOOL)isShowEmpty
{
  return !self.isLoading && [self.conversations count] == 0 && self.inboxTableView.infiniteScrollingView.state != SVInfiniteScrollingStateLoading;;
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  self.inboxTableView.userInteractionEnabled = self.conversations.count != 0;
  
  if ([self isShowEmpty]) {
    return 1;
  }
  return [self.conversations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isShowEmpty]) {
    return self.view.frame.size.height;
  }
  return IS_IPAD ? 135 : 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//#ifdef DEBUG ///////// START OF TEST /////////
//  NSLog(@"DON'T FORGET TO DELETE %s:%d", __FILE__, __LINE__);
//  return [InboxTableViewCell new];
//#endif ///////// END OF TEST /////////
  
  if ([self isShowEmpty]) {
    RingEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPTY_CELL_ID];
    cell.titleEmpty.text =  @"No messages";
    cell.subTitleEmpty.text = @"";
    cell.imageEmtpyIcon.image = [UIImage imageNamed:@"mail-emtpy"];
    return cell;
  }
  RingInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  cell.conversation = [self.conversations objectAtIndex:indexPath.row];
  return cell;
}

#pragma mark TableViewDataSourceDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isShowEmpty]) {
    return;
  }
  if ([self.conversations count] == 0) {
    return;
  }
  RingMessagesViewController *messagesVC = (RingMessagesViewController *)[RingUtility getViewControllerWithName:@"messages"];
  RingConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
  messagesVC.user = [conversation otherUser];
  [RingUtility removeUnreadConversationId:[[conversation otherUser] userId]];
  [self.navigationController pushViewController:messagesVC animated:YES];
}
@end
