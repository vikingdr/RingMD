//
//  RingBusyTimeViewController.m
//  Ring
//
//  Created by Medpats on 7/22/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusyTimeViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingBusyTimeView.h"
#import "RingBusyTimeAdd.h"

@interface RingBusyTimeViewController (){
  UIButton *_editButtonView;
  UIButton *_backButtonView;
}
@property (weak, nonatomic) IBOutlet UILabel *fromText;
@property (weak, nonatomic) IBOutlet UILabel *toText;
@property (weak, nonatomic) IBOutlet UIButton *addBusyTimeButton;
@property (weak, nonatomic) IBOutlet RingBusyTimeView *tableView;

@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (strong, nonatomic) RingBusyTimeAdd *busyTimeAdd;
@end

@implementation RingBusyTimeViewController

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

- (RingBusyTimeAdd *)busyTimeAdd
{
  if (!_busyTimeAdd) {
    NSInteger height = [RingUtility currentHeight] - self.tableView.frame.origin.y;
    _busyTimeAdd = [[RingBusyTimeAdd alloc] initWithFrame:CGRectMake(0, height, [RingUtility currentWidth], height)];
  }
  return _busyTimeAdd;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.tableView updateNecesseryStuff];
  [self decorateWhitebackground];
  [self decorateUIs];
  [self loadData];
  self.navigationItem.rightBarButtonItem = self.editButton;
  self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)loadData
{
  [RingBusyHour loadBusyHoursWithSuccess:^{
    self.tableView.busyHours = [[[RingUser currentCacheUser].busyHours allObjects] mutableCopy];
  }];
}

- (void)decorateUIs
{
  self.fromText.text = @"From";
  self.toText.text = @"To";
  
  self.fromText.backgroundColor = [UIColor ringOrangeColor];
  self.toText.backgroundColor = [UIColor ringOrangeColor];
  
  self.toText.font = self.fromText.font = [UIFont boldRingFontOfSize:[[RingConfigConstant sharedInstance] titleFontSize]];
  
  self.fromText.textColor = [UIColor whiteColor];
  self.toText.textColor = [UIColor whiteColor];
  
  [self.addBusyTimeButton setBackgroundColor:[UIColor ringMainColor]];
  [self.addBusyTimeButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.addBusyTimeButton.titleLabel.font = [UIFont boldRingFontOfSize:14];
}


- (void)editAction:(UIButton *)sender
{
  sender.selected = !sender.selected;
  [self.tableView setEditing:sender.selected];
}

- (void)hideBusyAddView
{
  [UIView animateWithDuration:0.5 animations:^{
    CGRect frame = self.busyTimeAdd.frame;
    frame.origin.y = frame.size.height + self.tableView.frame.origin.y;
    self.busyTimeAdd.frame = frame;
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.busyTimeAdd.alpha = 0;
  }];
}

- (void)cancelAction:(UIButton *)sender
{
  [self hideBusyAddView];
}

- (void)saveAction:(UIButton *)sender
{
  [self hideBusyAddView];
  [self.tableView addBusyTime:(self.busyTimeAdd.busyHour)];
}

- (IBAction)addAction:(UIButton *)sender
{
  [self.busyTimeAdd resetTime];
  [self.view addSubview:self.busyTimeAdd];
  [UIView animateWithDuration:0.5 animations:^{
    NSInteger height = [RingUtility currentHeight] - self.tableView.frame.origin.y;
    self.busyTimeAdd.frame = CGRectMake(0, self.tableView.frame.origin.y, [RingUtility currentWidth], height);
    self.busyTimeAdd.alpha = 1  ;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;
  }];
}
@end
