//
//  RingCallRequestDetailsViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/12/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingCallRequestDetailsViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingOpenTokViewController.h"
#import "RingMessagesViewController.h"
#import "RingDoctorProfileViewController.h"
#import "RingTimeSlotCell.h"
#import "NSMutableArray+Number.h"

@interface RingCallRequestDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UILabel *requestStatus;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIView *statusProfile;
@property (weak, nonatomic) IBOutlet UIImageView *requestImageStatus;
@property (weak, nonatomic) IBOutlet UILabel *callTimeText;

@property (weak, nonatomic) IBOutlet UITableView *timeSlotTableView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIView *actionsContainer;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *bottomAction;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (weak, nonatomic) RingTimeSlot *selectedTimeSlot;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property NSInteger topHeightConstant;
@property NSInteger bottomHeightConstant;

@property (weak, nonatomic) UIView *loadingCover;
@end

@implementation RingCallRequestDetailsViewController

- (RingUser *)user
{
  return self.callRequest.user;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self decorateWhitebackground];
  [self updateRequestStatus];
  [self initGestures];
  
  self.topHeightConstant = self.topHeightConstraint.constant;
  self.bottomHeightConstant = self.bottomHeightConstraint.constant;
  [self hideCallButton];
  [self hideAcceptButton];
  
  UIView *v = [UIView new];
  v.backgroundColor = [UIColor ringWhiteColor];
  v.frame = self.view.frame;
  [self.view addSubview:v];
  self.loadingCover = v;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [RingUtility removeUnreadRequestId:self.callRequest.callRequestId];
  [self loadData];
  self.title = self.callRequest.user.name;
  [self observeEvents];
}

- (void)initGestures
{
  if (!IS_DOCTOR) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap)];
    [self.profilePictureImage addGestureRecognizer:tapGesture];
  }
}

- (void)avatarTap
{
  RingDoctorProfileViewController *doctorProfile = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
  doctorProfile.doctor = [self.callRequest user];
  [self.navigationController pushViewController:doctorProfile animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRequestRemoved:) name:ME_requestRemoved object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRequestUpdated:) name:ME_requestUpdated object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserStatus) name:ME_userStatusChanged object:nil];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkRequestRemoved:(NSNotification *)notification
{
  [self updateUIs];
}

- (void)callRequestUpdated:(NSNotification *)notification
{
  [self updateUIs];
}

- (void)loadData
{
  [self.callRequest pullCallRequestDetailWithSuccess:^{
    [self updateUIs];
    [self.timeSlotTableView reloadData];
    
    [self.loadingCover removeFromSuperview];
  } modally:YES];
}

- (void)checkUserStatus
{
  if ([self.user isOnline]) {
    self.statusProfile.backgroundColor = [UIColor ringMainColor];
  } else {
    self.statusProfile.backgroundColor = [UIColor ringOffLineColor];
  }
}

- (void)updateUIs
{
  [self.profilePictureImage loadImageFromUrl:[NSURL URLWithString:self.user.avatar]];
  [self.statusProfile decorateCircle];
  [self checkUserStatus];
  self.profileName.text = self.user.name;
  self.profileName.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  
  self.requestStatus.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.requestStatus.textColor = [UIColor ringMainColor];
  self.callTimeText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.callTimeText.textColor = [UIColor ringLightMainColor];
  
  if (self.callRequest.isAccepted) {
    self.requestStatus.text = [[self.callRequest acceptedDate] defaultFormat];
    self.requestImageStatus.image = [UIImage imageNamed:@"approved"];
    self.callTimeText.hidden = NO;
    self.callTimeText.text =  [NSString stringWithFormat:@"(%@)", [[self.callRequest acceptedDate] afterDistanceTo:[NSDate date]]];
  } else if (self.callRequest.isRequested) {
    self.requestStatus.text = @"pending";
    self.requestImageStatus.image = [UIImage imageNamed:@"clock-orange"];
    self.callTimeText.hidden = YES;
  } else {
    self.requestStatus.text = self.callRequest.state;
    self.requestImageStatus.image = [UIImage imageNamed:@"clock-orange"];
    self.callTimeText.hidden = YES;
  }
  
  self.locationView.text = self.user.location;
  self.locationView.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.locationView.textColor = [UIColor ringDarkGrayBGColor];
  [self.locationView sizeToFit];
  [self.locationView layoutIfNeeded];
  self.locationView.textColor = [UIColor ringLightMainColor];
  if (!self.user.location || [self.user.location isEmpty]) {
    self.locationIcon.hidden = YES;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.descriptionText.text = self.callRequest.reason;
  self.descriptionText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.descriptionText.textColor = [UIColor ringDarkGrayBGColor];
  
  [self.sendMessageButton setTitleColor:[UIColor ringDarkGrayBGColor] forState:UIControlStateNormal];
  self.sendMessageButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.actionsContainer decorateEclipseWithRadius:3];
  [self.actionsContainer decorateBorder:1 andColor:[UIColor lightGrayColor]];
  
  [self.timeSlotTableView decorateEclipseWithRadius:3];
  [self.timeSlotTableView decorateBorder:1 andColor:[UIColor lightGrayColor]];
  self.timeSlotTableView.separatorInset = UIEdgeInsetsZero;
  self.timeSlotTableView.separatorColor = [UIColor lightGrayColor];
  
  self.actionButton.backgroundColor = [UIColor ringOrangeColor];
  [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.actionButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  [self decorateCallButton];
}

- (void)decorateCallButton
{
  if ([self.callRequest canCallNow]) {
    NSString *title = [NSString stringWithFormat:@"Start Call with %@", self.callRequest.user.name];
    [self.callButton setTitle:title forState:UIControlStateNormal];
    self.callButton.backgroundColor = [UIColor ringOrangeColor];
    self.callButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
    [self.callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.callButton decorateEclipseWithRadius:3];
    self.topHeightConstraint.constant = self.topHeightConstant;
    self.callButton.superview.hidden = NO;
  } else {
    [self hideCallButton];
  }
}

- (void)hideCallButton
{
  self.topHeightConstraint.constant = 0;
  self.callButton.superview.hidden = YES;
}

- (void)showAcceptButton
{
  NSString *title = [NSString stringWithFormat:@"Confirm Call for %@", [self.selectedTimeSlot.callTime compactFormat:YES]];
  [self.actionButton setTitle:title forState:UIControlStateNormal];
  
  self.bottomHeightConstraint.constant = self.bottomHeightConstant;
  self.bottomAction.hidden = NO;
}

- (void)hideAcceptButton
{
  self.bottomHeightConstraint.constant = 0;
  self.bottomAction.hidden = YES;
}

- (void)updateRequestStatus
{
  if (!self.callRequest.isRequested) {
    self.timeSlotTableView.hidden = YES;
    self.tableHeight.constant = 0;
  }
}

- (IBAction)callNowPressed:(id)sender {
  RingOpenTokViewController *openTok = (RingOpenTokViewController *)[RingUtility getViewControllerWithName:@"openTokVideoCall"];
  openTok.callRequest = [RingCallRequest findById:self.callRequest.callRequestId];
  [self.navigationController pushViewController:openTok animated:YES];
}

- (IBAction)acceptButtonPressed:(id)sender {
  [self.selectedTimeSlot approveTimeslotWithSuccess:^{
    [self updateRequestStatus];
    [self updateUIs];
    [self hideAcceptButton];
  }];
}

#pragma mark -- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.callRequest.timeSlots count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingTimeSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeSlotCell"];
  RingTimeSlot *timeSlot = [self.callRequest.timeSlots objectAtIndex:indexPath.row];
  cell.timeSlot = timeSlot;
  if (!IS_DOCTOR) {
    [cell hideSelectIcon];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedTimeSlot = [self.callRequest.timeSlots objectAtIndex:indexPath.row];
  if (IS_DOCTOR) {
    [self showAcceptButton];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  RingMessagesViewController *messageController = segue.destinationViewController;
  messageController.user = self.callRequest.user;
}
@end
