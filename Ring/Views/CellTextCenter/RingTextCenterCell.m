//
//  RingTextCenterCell.m
//  Ring
//
//  Created by Tan Nguyen on 9/16/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingTextCenterCell.h"

#import "Ring-Essentials.h"

@interface RingTextCenterCell()
@end

@implementation RingTextCenterCell

- (void)layoutSubviews
{
  [super layoutSubviews];
  NSInteger width;
  width = self.frame.size.width - 20;
  CGRect frame = self.textLabel.frame;
  frame.origin.x = 10;
  frame.size.width = width;
  self.textLabel.frame = frame;
  frame = self.detailTextLabel.frame;
  frame.origin.x = 10;
  frame.size.width = width;
  self.detailTextLabel.frame = frame;
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  self.imageView.backgroundColor = [UIColor clearColor];
  if (!_isButton) {
    self.textLabel.backgroundColor = [UIColor clearColor];
  } else {
    if (self.frame.size.width >= 320) {
      self.textLabel.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
    } else {
      self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
  }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  if (_isButton)
    return;
  [super setEditing:editing animated:animated];
}

- (void)decorateButton
{
  _isButton = YES;
  self.textLabel.textAlignment = NSTextAlignmentCenter;
  self.textLabel.textColor = [UIColor whiteColor];
  self.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  self.textLabel.backgroundColor = [UIColor ringMainColor];
  self.selectedBackgroundView = nil;
}
@end
