//
//  RingBusinessHourViewController.m
//  Ring
//
//  Created by Medpats on 7/1/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusinessHourViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingBusinessHourView.h"
#import "RingBusinessTimeAdd.h"

enum {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY,
  WEEK_DAY_COUNT
};

@interface RingBusinessHourViewController ()<RingBusinessHourDelegate> {
  BOOL editted;
  UIButton *_editButtonView;
  UIButton *_backButtonView;
}
@property (weak, nonatomic) RingUser *user;
@property (weak, nonatomic) IBOutlet RingBusinessHourView *businessHourView;

@property (weak, nonatomic) IBOutlet UIView *weekDaysView;
@property (weak, nonatomic) IBOutlet UILabel *fromText;
@property (weak, nonatomic) IBOutlet UILabel *toText;
@property (weak, nonatomic) IBOutlet UIButton *addBusinessHourButton;

@property (strong, nonatomic) RingBusinessTimeAdd *businessTimeAddView;
@property (strong, nonatomic) NSMutableArray *businessHourDays;

@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@end

@implementation RingBusinessHourViewController

- (NSMutableArray *)businessHourDays
{
  if (!_businessHourDays) {
    _businessHourDays = [@[@[],@[],@[],@[],@[],@[],@[]] mutableCopy];
  }
  return _businessHourDays;
}

- (UIBarButtonItem *)saveButton
{
  if (!_saveButton) {
    UIButton *button = [UIButton ringButtonWithText:@"Save"];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    _saveButton = [[UIBarButtonItem alloc] initWithCustomView:button];
  }
  return _saveButton;
}

- (UIBarButtonItem *)cancelButton
{
  if (!_cancelButton) {
    UIButton *button = [UIButton ringButtonWithText:@"Cancel"];
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    _cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
  }
  return _cancelButton;
}

- (UIBarButtonItem *)editButton
{
  if (!_editButton) {
    _editButtonView = [UIButton ringEditButton];
    [_editButtonView addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    _editButton = [[UIBarButtonItem alloc] initWithCustomView:_editButtonView];
  }
  return _editButton;
}

- (UIBarButtonItem *)backButton
{
  if (!_backButton) {
//    _backButtonView = [UIButton ringBackButton];
    [_backButtonView addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    _backButton = [[UIBarButtonItem alloc] initWithCustomView:_backButtonView];
  }
  return _backButton;
}

- (RingBusinessTimeAdd *)businessTimeAddView
{
  if (!_businessTimeAddView) {
    NSInteger height = [RingUtility currentHeight] - self.businessHourView.frame.origin.y;
    _businessTimeAddView = [[RingBusinessTimeAdd alloc] initWithFrame:CGRectMake(0, height, [RingUtility currentWidth], height)];
  }
  return _businessTimeAddView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.businessHourView.businessHourDelegate = self;
  [self.businessHourView updateNecesseryStuff];
  [self decorateWhitebackground];
  [self decorateUIs];
  [self decorateWeekDays];
  [self loadBusinessHour];
  self.navigationItem.rightBarButtonItem = self.editButton;
  self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  if (editted) {
    [RingBusinessHour submitBusinessHour:self.businessHourDays toServerWithSuccess:^{
    }];
  }
}

- (void)loadBusinessHour
{
  [RingBusinessHour loadBusinessHoursWithSuccess:^(NSMutableArray *businessHours) {
    self.businessHourDays = businessHours;
    [self setActiveWeekDayWithIndex:MONDAY];
  }];
}

- (void)decorateUIs
{
  self.fromText.text = @"From";
  self.toText.text = @"To";
  
  self.weekDaysView.backgroundColor = [UIColor ringWhiteColor];
  self.fromText.backgroundColor = [UIColor ringOrangeColor];
  self.toText.backgroundColor = [UIColor ringOrangeColor];
  
  self.toText.font = self.fromText.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  
  self.fromText.textColor = [UIColor whiteColor];
  self.toText.textColor = [UIColor whiteColor];
  
  [self.addBusinessHourButton setBackgroundColor:[UIColor ringMainColor]];
  [self.addBusinessHourButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.addBusinessHourButton.titleLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}


- (void)editAction:(UIButton *)sender
{
  sender.selected = !sender.selected;
  [self.businessHourView setEditing:sender.selected];
}

- (void)hideBusyAddView
{
  [UIView animateWithDuration:0.5 animations:^{
    CGRect frame = self.businessTimeAddView.frame;
    frame.origin.y = frame.size.height + self.businessHourView.frame.origin.y;
    self.businessTimeAddView.frame = frame;
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.businessTimeAddView.alpha = 0;
  }];
}

- (void)cancelAction:(UIButton *)sender
{
  [self hideBusyAddView];
}

- (void)saveAction:(UIButton *)sender
{
  [self hideBusyAddView];
  [self.businessHourView addBusinessHour:(self.businessTimeAddView.businessHour)];
}

- (IBAction)addAction:(UIButton *)sender
{
  [self.businessTimeAddView resetTime];
  [self.view addSubview:self.businessTimeAddView];
  [UIView animateWithDuration:0.5 animations:^{
    NSInteger height = [RingUtility currentHeight] - self.businessHourView.frame.origin.y;
    self.businessTimeAddView.frame = CGRectMake(0, self.businessHourView.frame.origin.y, [RingUtility currentWidth], height);
    self.businessTimeAddView.alpha = 1  ;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;
  }];
}

- (void)decorateWeekDays
{
  for (NSInteger i = 0; i < WEEK_DAY_COUNT; ++i) {
    UIButton *button  = [self weekDayButtonAtIndex:i];
    [self.weekDaysView addSubview:button];
  }
}

- (void)setActiveWeekDayWithIndex:(NSInteger)index
{
  for (UIButton *button in [self.weekDaysView subviews]){
      [button.titleLabel setFont:[UIFont ringFontOfSize:[RingConfigConstant sharedInstance].smallFontSize]];
  }
  [[(UIButton *)self.weekDaysView.subviews[index] titleLabel] setFont:[UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].smallFontSize]];
  
  self.businessHourView.index = index;
  self.businessHourView.businessHours = [[self.businessHourDays objectAtIndex:index] mutableCopy];
}

- (UIButton *)weekDayButtonAtIndex:(NSInteger )index
{
  CGFloat width = [RingUtility currentWidth]/WEEK_DAY_COUNT;
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(index * width, 0, width, self.weekDaysView.frame.size.height);
  NSString *title;
  switch (index) {
    case MONDAY:
      title = @"MON";
      break;
    case TUESDAY:
      title = @"TUE";
      break;
    case WEDNESDAY:
      title = @"WED";
      break;
    case THURSDAY:
      title = @"THU";
      break;
    case FRIDAY:
      title = @"FRI";
      break;
    case SATURDAY:
      title = @"SAT";
      break;
    case SUNDAY:
      title = @"SUN";
      break;
    default:
      break;
  }
  button.tag = index;
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:self action:@selector(weekDayPressed:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  return button;
}

- (void)weekDayPressed:(UIButton *)button
{
  [self setActiveWeekDayWithIndex:button.tag];
}

#pragma mark BusinessHourDelegate
- (void)businessHourEditted
{
  editted = YES;
  self.businessHourDays[self.businessHourView.index] = [self.businessHourView.businessHours copy];
}
@end
