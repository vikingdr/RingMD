//
//  RingRequestCallViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/10/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingRequestCallViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingPaymentRequestViewController.h"
#import "RingPickRequestDateViewController.h"

@interface MarginlessUITableViewCell : UITableViewCell
@end

@implementation MarginlessUITableViewCell
- (id)init
{
  self = [super init];
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGRect tmpFrame;
  CGFloat delta = -self.textLabel.frame.origin.x;
  
  tmpFrame = self.imageView.frame;
  tmpFrame.origin.x += delta;
  tmpFrame.size.width -= delta;
  self.imageView.frame = tmpFrame;
  
  tmpFrame = self.textLabel.frame;
  tmpFrame.origin.x += delta;
  tmpFrame.size.width -= delta;
  self.textLabel.frame = tmpFrame;
  
  tmpFrame = self.detailTextLabel.frame;
  tmpFrame.origin.x += delta;
  tmpFrame.size.width -= delta;
  self.detailTextLabel.frame = tmpFrame;
}
@end

@interface RingRequestCallViewController ()<RingPickRequestDateDelegate, UIGestureRecognizerDelegate>
{
  NSInteger currentSelectedIndex;
  BOOL _didAlreadySubmit;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *provideCallText;
@property (weak, nonatomic) IBOutlet UILabel *requestTypeText;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeText;
@property (weak, nonatomic) IBOutlet UITextView *reasonValueText;
@property (weak, nonatomic) IBOutlet UISwitch *requestTypeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *requestTypeSwitchText;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeSubText;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UITableView *timeSlotTableView;

@property (strong, nonatomic) RingCallRequest *callRequest;
@property (strong, nonatomic) RingTimeSlot *timeSlot1;
@property (strong, nonatomic) RingTimeSlot *timeSlot2;
@property (strong, nonatomic) RingTimeSlot *timeSlot3;
@property (strong, nonatomic) RingPickRequestDateViewController *pickDate;
@end

@implementation RingRequestCallViewController

- (RingPickRequestDateViewController *)pickDate
{
  if (!_pickDate) {
    _pickDate = [[RingPickRequestDateViewController alloc] initWithNibName:@"PickRequestDate" bundle:nil];
    _pickDate.dateDelegate = self;
  }
  return _pickDate;
}

- (RingTimeSlot *)timeSlot1 {
  if (!_timeSlot1) {
    _timeSlot1 = [RingTimeSlot insertWithTime:[NSDate tomorrow8AM]];
  }
  return _timeSlot1;
}

- (RingTimeSlot *)timeSlot2 {
  if (!_timeSlot2) {
    _timeSlot2 = [RingTimeSlot insertWithTime:[NSDate next2Days8AM]];
  }
  return _timeSlot2;
}

- (RingTimeSlot *)timeSlot3 {
  if (!_timeSlot3) {
    _timeSlot3 = [RingTimeSlot insertWithTime:[NSDate next3Days8AM]];
  }
  return _timeSlot3;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.callRequest = [RingCallRequest createWithUser:self.doctor];
  self.title = [NSString stringWithFormat:@"Call %@", self.doctor.name];
  [self loadSugestedSlots];
  [self decorateWhitebackground];
  [self decorateUIs];
  [self initGestures];
}

- (void)viewDidAppear:(BOOL)animated {
  if(_didAlreadySubmit) {
    [self.callRequest cancelRequestWithSuccess:nil];
    _didAlreadySubmit = NO;
  }
  
  for(NSIndexPath *path in self.timeSlotTableView.indexPathsForSelectedRows) {
    [self.timeSlotTableView deselectRowAtIndexPath:path animated:YES];
  }
}

- (void)loadSugestedSlots
{
  [self.doctor loadSugestedSlotsWithSuccess:^(NSArray *dates) {
    if ([dates count] == 3) {
      _timeSlot1 = dates[0];
      _timeSlot2 = dates[1];
      _timeSlot3 = dates[2];
    }
    [self.timeSlotTableView reloadData];
  }];
}

- (void)initGestures
{
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
  tapGesture.delegate = self;
  [self.scrollViewContainer addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
  [self.reasonValueText resignFirstResponder];
}

- (void)decorateUIs
{
  self.provideCallText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.provideCallText.textColor = [UIColor blackColor];
  
  [self.reasonValueText decorateEclipseWithRadius:3];
  [self.reasonValueText decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  
  self.requestTypeSwitchText.textColor = [UIColor blackColor];
  self.requestTypeSwitchText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.requestTypeText.textColor = [UIColor ringLightMainColor];
  self.requestTypeText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  
  if (self.callRequest.numberPhone && self.callRequest.numberPhone.length > 6) {
    self.requestTypeSwitch.enabled = YES;
    self.requestTypeText.text = [NSString stringWithFormat:@"We recommend using the RingMD app or website to talk to your doctor. If you choose otherwise then %@ will call you on %@. Your number will be kept confidential.", self.doctor.name, self.callRequest.numberPhone];
  } else {
    self.requestTypeSwitch.on = YES;
    self.requestTypeSwitch.enabled = NO;
    self.requestTypeText.text = [NSString stringWithFormat:@"We don’t currently have a phone number on record for you. If, rather than using the RingMD app or website to make a video call, you prefer %@ to call you on your phone then please first add your phone number to your profile. Your number will be kept confidential.", self.doctor.name];
  }
  
  self.dateTimeText.textColor = [UIColor blackColor];
  self.dateTimeText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.dateTimeSubText.text = [NSString stringWithFormat:@"Propose three times for your call based on your doctor’s schedule. %@ will confirm one of your suggestions or will make a new proposal.", self.doctor.name];
  self.dateTimeSubText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize];
  self.dateTimeSubText.textColor = [UIColor ringLightMainColor];
  
  [self.processButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.processButton.backgroundColor = [UIColor ringOrangeColor];
  self.processButton.titleLabel.font = [UIFont boldRingFontOfSize:14];
  
  self.timeSlotTableView.rowHeight = self.timeSlotTableView.frame.size.height / 3;
}

- (IBAction)submitCallRequest:(id)sender
{
  self.callRequest.type = self.requestTypeSwitch.on ? VIDEO_REQUEST_TYPE : CALL_REQUEST_TYPE;
  self.callRequest.reason = self.reasonValueText.text;
  self.callRequest.durationEstimate = @(30);
  self.callRequest.timeSlots = [[NSOrderedSet alloc] initWithArray:@[self.timeSlot1, self.timeSlot2, self.timeSlot3]];
  if ([self.callRequest validate]) {
    [self.callRequest submitRequest:^{
      RingPaymentRequestViewController *paymentRequest = (RingPaymentRequestViewController *)[RingUtility getViewControllerWithName:@"paymentRequestView"];
      _didAlreadySubmit = YES;
      paymentRequest.doctor = self.doctor;
      paymentRequest.callRequest = self.callRequest;
      [self.navigationController pushViewController:paymentRequest animated:YES];
    }];
  }
}

#pragma mark -- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MarginlessUITableViewCell *cell = [MarginlessUITableViewCell new];
  cell.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = self.timeSlot1.callTime.defaultFormat;
      break;
    case 1:
      cell.textLabel.text = self.timeSlot2.callTime.defaultFormat;
      break;
    case 2:
      cell.textLabel.text = self.timeSlot3.callTime.defaultFormat;
      break;
  }
  
  return cell;
}

- (void)configureTimeSlots:(NSInteger)index // my eyes! they burn!
{
  RingTimeSlot *time1;
  RingTimeSlot *time2;
  if (index == 0) {
    time1 = self.timeSlot2;
    time2 = self.timeSlot3;
    self.pickDate.initialDate = self.timeSlot1.callTime;
  } else if (index == 1) {
    time1 = self.timeSlot1;
    time2 = self.timeSlot3;
    self.pickDate.initialDate = self.timeSlot2.callTime;
  } else {
    assert(index == 2);
    time1 = self.timeSlot1;
    time2 = self.timeSlot2;
    self.pickDate.initialDate = self.timeSlot3.callTime;
  }
  
  self.pickDate.selectedSlots = @[@{@"start_time" : [time1.callTime sumbitServerFormat]}, @{@"start_time" : [time2.callTime sumbitServerFormat]}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  currentSelectedIndex = indexPath.row;
  self.pickDate.doctor = self.doctor;

  [self configureTimeSlots:indexPath.row];
  [self.navigationController pushViewController:self.pickDate animated:YES];
}

#pragma mark -- TAPTOUCH
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  return self.reasonValueText.isFirstResponder;
}

#pragma mark -- RingDatePickerDelegate
- (void)pickRequestDateViewController:(id)pickRequestDateViewController dateChanged:(NSDate *)date
{
  switch (currentSelectedIndex) {
    case 0:
      self.timeSlot1.callTime = date;
      break;
    case 1:
      self.timeSlot2.callTime = date;
      break;
    case 2:
      self.timeSlot3.callTime = date;
      break;
    default:
      assert(false);
  }
  [self.timeSlotTableView reloadData];
  [self.timeSlotTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}
@end
