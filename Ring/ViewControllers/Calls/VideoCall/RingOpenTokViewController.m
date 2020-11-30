//
//  RingOpenTokViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/13/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingOpenTokViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"
#import "Ring-Models.h"

#import <Opentok/Opentok.h>

#import "RingMessageChatCell.h"
#import "RingMedicalHistoryViewController.h"
#import "RingMedialHistory.h"

#define CELL_ID @"messageChatCell"

@interface RingOpenTokViewController ()<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate, UITextFieldDelegate>
{
  OTSession* _session;
  OTPublisher* _publisher;
  OTSubscriber* _subscriber;
  BOOL _loaded;
  BOOL _connected;
  
  NSInteger currentPage;
  AVAudioPlayer *player;
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNameOnly;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePictureView;
@property (weak, nonatomic) IBOutlet UIView *controlsContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *hangOffButton;

@property (weak, nonatomic) IBOutlet UIView *chatBoxContainer;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alignBottomChatMessage;

@property (weak, nonatomic) IBOutlet UIView *chatContentContainer;
@property (weak, nonatomic) IBOutlet UIButton *chatContentCollapseButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alignBottomChatContent;

@property (weak, nonatomic) IBOutlet RingMedialHistory *medicalHistorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMedicalHistory;

@property (strong, nonatomic) NSTimer *timer;
@end

static bool subscribeToSelf = NO;

@implementation RingOpenTokViewController

- (RingUser *)user
{
  return self.callRequest.user;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self decorateUIs];
  self.title = @"Calling";
  _loaded = false;
  self.userNameOnly.hidden = YES;
  [self initTableView];
  [self decorateMedicalHistoryButton];
  [self initMedicalHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (!_loaded) {
    [self getOpenTokSession];
    _loaded = YES;
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [self observeModelEvents];
  [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self doDisconnect];
  [super viewWillDisappear:animated];
  [self unObserveModelEvents];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self unregisterForKeyboardNotifications];
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
  [self refreshData];
}

- (void)refreshData
{
  currentPage = 0;
  [self loadNextDataPage];
}

- (void)userStatusChanged:(NSNotification *)notification
{
  [self reloadTableview];
}

- (void)updateViewAfterConnect
{
  _connected = YES;
  [self.view bringSubviewToFront:_publisher.view];
  [self.view bringSubviewToFront:self.controlsContainer];
  self.hangOffButton.enabled = YES;
  self.userNameOnly.hidden = NO;
}

- (void)initTableView
{
  [self.tableView registerNib:[UINib nibWithNibName:@"MessageChat" bundle:nil] forCellReuseIdentifier:CELL_ID];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self loadNextDataPage];
}

- (void)loadNextDataPage
{
  NSInteger msgCount = self.user.latestMessages.count;
  [self.user loadMessageWithPage:(currentPage + 1) andSuccess:^{
    ASSERT_MAIN_LOOP;
    if(self.user.latestMessages.count > msgCount) {
      currentPage += 1;
      [self loadNextDataPage];
    }
    [self reloadTableview];
    [self scrollToBottom];
  }];
}

- (void)reloadTableview
{
  [self.tableView reloadData];
  [player stop];
}

- (void)decorateUIs
{
  [self.userProfilePictureView loadImageFromUrl:[self.callRequest.user bestQualityAvatarUrl]];
  self.userName.textColor = [UIColor whiteColor];
  NSString *title = [NSString stringWithFormat:@"Waiting for %@", self.callRequest.user.name];
  self.userName.text = title;
  self.userName.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  self.userNameOnly.textColor = [UIColor whiteColor];
  self.userNameOnly.text = self.callRequest.user.name;
  self.userNameOnly.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
 
  self.lblTimer.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.lblTimer.textColor = [UIColor whiteColor];
  
  [self.hangOffButton decorateEclipseWithRadius:3];
  
  self.view.backgroundColor = [UIColor colorWithRed:0.235 green:0.702 blue:0.906 alpha:1];
  [self.cancelButton decorateEclipseWithRadius:3];
  [self.cancelButton setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
  self.cancelButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  [self.chatContentCollapseButton decorateCircle];
    [self.chatContentCollapseButton decorateBorder:1 andColor:[UIColor lightGrayColor]];
  [self.chatContentCollapseButton setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
  self.chatContentCollapseButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  [self.messageText decorateEclipseWithRadius:3];
  [self.messageText decorateBorder:1 andColor:[UIColor lightGrayColor]];
  self.messageText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  self.messageText.leftViewMode = UITextFieldViewModeAlways;
}

- (void)disableAllButtons
{
  self.voiceButton.enabled = NO;
  self.videoButton.enabled = NO;
  self.hangOffButton.enabled = NO;
}

- (void)enableAllButtons
{
  self.voiceButton.enabled = YES;
  self.videoButton.enabled = YES;
  self.hangOffButton.enabled = YES;
}

- (void)initMedicalHistory
{
  self.medicalHistorView.user = self.callRequest.caller;
  [self.callRequest.caller getFullUserInfoWithSuccess:^{ } modally:YES];
}

- (void)showMedicalHistory
{
  [UIView animateWithDuration:0.5 animations:^{
    self.leftMedicalHistory.constant = 0;
    [self.medicalHistorView layoutIfNeeded];
  }];
}

- (void)hideMedicalHistory
{
  [UIView animateWithDuration:0.5 animations:^{
    self.leftMedicalHistory.constant = -self.medicalHistorView.frame.size.width;
    [self.medicalHistorView layoutIfNeeded];
  }];
}

- (void)getOpenTokSession
{
  [self.callRequest pullOpenTokChatRoom:^{
    _session  = [[OTSession alloc] initWithApiKey:openTokAPIKEY sessionId:self.callRequest.openTokSesion.sessionId delegate:self];
    [self doConnect];
  }];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return NO;
  } else {
    return YES;
  }
}

- (void)updateSubscriber {
  for (NSString* streamId in _session.streams) {
    if (streamId != nil && ![streamId isEmpty]) {
      OTStream* stream = [_session.streams valueForKey:streamId];
      if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
        _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        break;
      }
    }
  }
}

- (void)doDisconnect
{
  OTError *error = nil;
  
  [_session disconnect:&error];
  if (error)
  {
//    [self showAlert:[error localizedDescription]];
  }
}

- (IBAction)stopCallButtonPressed:(id)sender
{
  [self.timer invalidate];
  self.lblTimer.text = @"00:00";
  [self disableAllButtons];
  double delayInSeconds = 0.0;
  
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    if (_connected) {
      [self.callRequest requestFinishedSessionWithSuccess:^{
        [self dismissOpenTokViewController];
      } andFailed:^{
        [self dismissOpenTokViewController];
      }];
    } else {
      [self dismissOpenTokViewController];
    }
  });
  [self doDisconnect];
}

- (IBAction)medicalHistoryAction:(UIButton *)sender
{
  sender.selected = !sender.selected;
  if (sender.selected) {
    [self showMedicalHistory];
  } else {
    [self hideMedicalHistory];
  }
}

- (IBAction)microButtonPressed:(UIButton *)sender
{
  sender.selected = !sender.selected;
  _publisher.publishAudio = !sender.selected;
}

- (IBAction)videoButtonPressed:(UIButton *)sender
{
  sender.selected = !sender.selected;
  _publisher.publishVideo = !sender.selected;
}

- (IBAction)messagePressed:(id)sender {
  self.controlsContainer.hidden = YES;
  self.chatBoxContainer.hidden = NO;
  [self showChatContent];
}

- (IBAction)cancelMessagePressed:(id)sender {
  self.controlsContainer.hidden = NO;
  self.chatBoxContainer.hidden = YES;
  [self hideChatContent];
  [self.messageText resignFirstResponder];
}

- (IBAction)collapsePressed:(id)sender {
  [self hideChatContent];
}

- (void)showChatContent
{
  [UIView animateWithDuration:1.0 animations:^{
    self.alignBottomChatContent.constant = 50;
    self.chatContentCollapseButton.selected = YES;
    [self.view layoutIfNeeded];
  }];
}

- (void)hideChatContent
{
  [UIView animateWithDuration:1.0 animations:^{
    self.alignBottomChatContent.constant = - 50 - self.chatContentContainer.frame.size.height;
    self.chatContentCollapseButton.selected = NO;
    [self.view layoutIfNeeded];
  }];
}

- (void)animateChatChangeHeight:(CGFloat)height
{
  [UIView animateWithDuration:1.0 animations:^{
    self.alignBottomChatMessage.constant += height;
      self.alignBottomChatContent.constant += height;
    [self.chatBoxContainer layoutIfNeeded];
  }];
}

- (void)updateTimeCount
{
  NSDate *startDate = [self.timer userInfo];
  self.lblTimer.text = [NSString stringWithFormat:@"%@", [startDate countDistanceTo:[NSDate date]]];
}

#pragma mark -- keyboard
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)unregisterForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  if ([RingUtility isLandscape]) {
    keyBoardHeight = kbSize.width;
  }
  [self animateChatChangeHeight:keyBoardHeight];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  if ([RingUtility isLandscape]) {
    keyBoardHeight = kbSize.width;
  }
  [self animateChatChangeHeight:-keyBoardHeight];
}

#pragma mark - Table view data source
- (RingMessage *)messageAtIndex:(NSInteger)index
{
  return [self.user.latestMessages objectAtIndex:[self.user.latestMessages count] - index - 1];
}

- (BOOL)isYourMessage:(NSIndexPath *)indexPath
{
  RingMessage *message = [self messageAtIndex:indexPath.row];
  return [message.sender.userId isEqualToNumber:currentUser.userId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.user.latestMessages count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (RingMessageChatCellAvatarBehavior)avatarBehaviorAtIndexPath:(NSIndexPath *)indexPath
{
  NSNumber *currentSenderId = [self messageAtIndex:indexPath.row].sender.userId;
  
  if(indexPath.row > 0
     && [[self messageAtIndex:indexPath.row - 1].sender.userId isEqualToNumber:currentSenderId]) {
    return RingMessageChatCellHideAvatar;
  }
  
  
  if(indexPath.row < self.user.latestMessages.count - 1
     && [[self messageAtIndex:indexPath.row + 1].sender.userId isEqualToNumber:currentSenderId]) {
    return RingMessageChatCellShowAvatarAndOverflow;
  }
  
  return RingMessageChatCellShowAvatarAndDoNotOverflow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingMessage *message = [self messageAtIndex:indexPath.row];
  RingMessageChatCell *chatMessageCell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  chatMessageCell.delegate = self;
  chatMessageCell.message = message;
  [chatMessageCell decorateAttachFileFromMessage:message];
  [chatMessageCell initGestures];
  [chatMessageCell updateLayout:[self avatarBehaviorAtIndexPath:indexPath] != RingMessageChatCellHideAvatar];
  return chatMessageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
  return [RingMessageChatCell cellHeightForMessage:[self messageAtIndex:indexPath.row]
                                            avatar:[self avatarBehaviorAtIndexPath:indexPath]];
}

- (void)scrollToBottom
{
  NSInteger count = [self.tableView numberOfRowsInSection:0];
  if (count > 0)
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark --UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [currentUser relyMessage:textField.text toUser:self.user withSuccess:^{
    self.messageText.text = @"";
    [self.tableView reloadData];
  }];
  return YES;
}

#pragma mark - OpenTok methods

- (void)doConnect
{
  OTError *error = nil;
  
  [_session connectWithToken:self.callRequest.openTokSesion.token error:&error];
  if (error)
  {
    [self showAlert:[error localizedDescription]];
  }
}

- (void)doPublish
{
  _publisher =
  [[OTPublisher alloc] initWithDelegate:self
                                   name:currentUser.name];
  
  OTError *error = nil;
  [_session publish:_publisher error:&error];
  if (error)
  {
    [self showAlert:[error localizedDescription]];
  }
  
  [self.view addSubview:_publisher.view];
  if (IS_IPAD) {
    [_publisher.view setFrame:CGRectMake([RingUtility currentWidth] - 140, [RingUtility currentHeight] - 220, 140, 140)];
  } else {
    [_publisher.view setFrame:CGRectMake([RingUtility currentWidth] - 70, [RingUtility currentHeight] - 120, 70, 70)];
  }
  self.voiceButton.enabled = YES;
  self.videoButton.enabled = YES;
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher {
  [_publisher.view removeFromSuperview];
  _publisher = nil;
  // this is a good place to notify the end-user that publishing has stopped.
}

- (void)doSubscribe:(OTStream*)stream
{
  _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
  
  OTError *error = nil;
  [_session subscribe:_subscriber error:&error];
  if (error)
  {
    [self showAlert:[error localizedDescription]];
  }
}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
  [self showAlert:[NSString stringWithFormat:@"Could not publish."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
  [self showAlert:[NSString stringWithFormat:@"Could not subscribe to stream %@.", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
  [self showAlert:[NSString stringWithFormat:@"Could not connect to session %@.", session.sessionId]];
}

- (void)cleanupSubscriber
{
  [_subscriber.view removeFromSuperview];
  _subscriber = nil;
}

# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
  NSLog(@"OpenTok session connected (%@)", session.sessionId);
  
  // Step 2: We have successfully connected, now instantiate a publisher and
  // begin pushing A/V streams into OpenTok.
  [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
  NSString* alertMessage =
  [NSString stringWithFormat:@"OpenTok session disconnected: (%@)",
   session.sessionId];
  NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}

- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
  NSLog(@"OpenTok stream created (%@)", stream.streamId);
  
  // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
  // have seen on the OpenTok session.
  if (nil == _subscriber && !subscribeToSelf)
  {
    [self doSubscribe:stream];
  }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
  NSLog(@"OpenTok stream destroyed (%@)", stream.streamId);
  
  if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
  {
    [self cleanupSubscriber];
  }
}

- (void)session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
  NSLog(@"OpenTok connection created (%@): %@", connection.connectionId, connection.data);
}

- (void)session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
  NSLog(@"OpenTok connection destroyed (%@)", connection.connectionId);
  if ([_subscriber.stream.connection.connectionId
       isEqualToString:connection.connectionId])
  {
    [self dismissOpenTokViewController];
    [self cleanupSubscriber];
  }
}

# pragma mark - OTSubscriberKit delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
  NSLog(@"OpenTok subscriber connected to stream");
  
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeCount) userInfo:[NSDate date] repeats:YES];
  assert(_subscriber == subscriber);
  if (IS_IPAD) {
    [_subscriber.view setFrame:CGRectMake(0, 66, [RingUtility currentWidth], [RingUtility currentHeight] - 66)];
  } else {
    [_subscriber.view setFrame:CGRectMake(0,66, [RingUtility currentWidth], [RingUtility currentHeight] - 66)];
  }
  [_subscriber.view removeFromSuperview];
  [self.view insertSubview:_subscriber.view belowSubview:self.chatContentContainer];
  
  [self updateViewAfterConnect];
}

- (void)subscriberVideoDisabled:(OTSubscriberKit*)subscriber
{
  [self showAlert:@"Due to network quality issues, incoming video was disabled."];
}

- (void)showAlert:(NSString*)string {
  NSLog(@"OpenTok error: %@", string);
  [UIViewController showMessage:@"Connection failed." withTitle:@"Video Call Error"];
}

- (void)dismissOpenTokViewController
{
  [[RingNavigationController sharedNavigationController] popToMenuChild];
}
@end
