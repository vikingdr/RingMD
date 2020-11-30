//
//  RingMedicalHistoryViewController.m
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingMedicalHistoryViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingQuestionCell.h"
#import "RingExtraPatientQuestion.h"
#import "RingMedialHistory.h"

@interface RingMedicalHistoryViewController ()<RingQuetionCellDelegate> {
  NSInteger currentSelectedIndex;
}
@property (weak, nonatomic) IBOutlet RingMedialHistory *historyView;
@property (weak, nonatomic) UIScrollView *scrollViewContainer;
@end

@implementation RingMedicalHistoryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initTableView];
  currentSelectedIndex = -1;
  _scrollViewContainer = self.historyView;
  [self decorateWhitebackground];
  if (self.editable) {
    [self decorateEditButton];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unregisterForKeyboardNotifications];
  if (self.editing) {
    [self.user updatePatientHistory:^{
      
    }];
  }
}

- (void)initTableView
{
  self.historyView.user = self.user;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  [self.historyView setEditing:editing animated:animated];
  if (!editing) {
    [self.user updatePatientHistory:^{
      
    }];
  }
}

#pragma mark --RingQuestionCell
- (void)refreshTableKeepOpenAtIndex:(NSInteger)index
{
  currentSelectedIndex = index;
  [self.historyView reloadData];
}

- (void)scrollToIndex:(NSInteger)index
{
  currentSelectedIndex = index;
  [self scrollToVisible];
}

#pragma mark --KEYBOARD
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShown:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)unregisterForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)scrollToVisible
{
  NSIndexPath *indexPath;
  indexPath = [NSIndexPath indexPathForRow:currentSelectedIndex % 100 inSection:currentSelectedIndex/100];
  [self.historyView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGFloat keyBoardHeight = kbSize.height;
  if ([RingUtility isLandscape]) {
    keyBoardHeight = kbSize.width;
  }
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0);
  self.scrollViewContainer.contentInset = contentInsets;
  self.scrollViewContainer.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollViewContainer.contentInset = contentInsets;
  self.scrollViewContainer.scrollIndicatorInsets = contentInsets;
}
@end
