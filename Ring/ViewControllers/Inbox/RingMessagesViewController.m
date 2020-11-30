//
//  RingMessagesViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/18/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingMessagesViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "UIViewController+HandleKeyboard.h"
#import "RingSendBox.h"

@interface RingMessagesViewController ()<RingSendBoxDeledate>
{
  ConversationDelegate *_conversationDelegate;
  NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) RingSendBox *sendBox;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alignBottom;

@property (strong, nonatomic) UIView *activeField;
@property (strong, nonatomic) RingMessage *lastMessage;
@end

@implementation RingMessagesViewController

- (RingSendBox *)sendBox
{
  if (!_sendBox) {
    _sendBox = [RingSendBox initSendBox];
    _activeField = _sendBox.messageBox;
    _sendBox.delegate = self;
    _sendBox.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
  }
  return _sendBox;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self initTableView];
  self.title = self.user.name;
  [self initGestures];
  [self decorateUIs];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self observeModelEvents];
  [self registerForKeyboardNotifications];
  
  _conversationDelegate = [[ConversationDelegate alloc] initWithCurrentUserName:currentUser.name
                                                     currentUserAvatarURLString:currentUser.avatar
                                                                    otherUserId:self.user.userId.integerValue];
  _tableView.delegate = _conversationDelegate;
  _tableView.dataSource = _conversationDelegate;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveModelEvents];
  [self unregisterForKeyboardNotifications];
}

- (void)initGestures
{
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
  [self.view addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
  [self.activeField resignFirstResponder];
}

- (void)decorateUIs
{
  [self.bottomView addSubview:self.sendBox];
}

- (void)initTableView
{
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [ConversationDelegate initializeTableView:self.tableView];
}

- (void)observeModelEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:ME_messageUpdated object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:ME_userStatusChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:CE_onlinechanged object:nil];
}

- (void)unObserveModelEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)newMessage:(NSNotification *)notification
{
  self.user = [RingUser findById:self.user.userId];
  [self.tableView reloadData];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self.tableView reloadData];
}

- (RingMessage *)messageAtIndex:(NSInteger)index
{
  return [self.user.latestMessages objectAtIndex:[self.user.latestMessages count] - index - 1];
}

- (BOOL)isYourMessage:(NSIndexPath *)indexPath
{
  RingMessage *message = [self messageAtIndex:indexPath.row];
  return [message.sender.userId isEqualToNumber:currentUser.userId];
}

#pragma mark - SendBoxDelegate
- (void)sendWithText:(NSString *)text
{
  [currentUser relyMessage:text toUser:self.user withSuccess:^{
    [self.sendBox resetFields];
    [_conversationDelegate fetchNewData:self.tableView];
  }];
}

- (void)sendWithImage:(UIImage *)image andLocalUrl:(NSString *)url
{
  [currentUser relyImage:image toUser:self.user withSuccess:^{
    [self.sendBox resetFields];
    [_conversationDelegate fetchNewData:self.tableView];
  }];
}

#pragma mark --KEYBOARD
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  [UIView animateWithDuration:0.4 animations:^{
    self.alignBottom.constant = keyBoardHeight;
    [self.scrollViewContainer layoutIfNeeded];
  }];
  
  [self scrollToBottom];
}

- (void)scrollToBottom
{
  NSInteger count = [self.tableView numberOfRowsInSection:0];
  if (count > 0)
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  self.alignBottom.constant = 0;
}
@end
