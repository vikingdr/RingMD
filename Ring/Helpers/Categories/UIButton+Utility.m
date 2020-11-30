//
//  UIButton+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 11/15/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "UIButton+Utility.h"

#import "UIFont+Utility.h"
#import "UIImage+Utility.h"
#import "UIColor+Utility.h"

@implementation UIButton (Utility)
+ (UIButton *)ringEditButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 50, 30);
  [button setTitle:@"Edit" forState:UIControlStateNormal];
  [button setTitle:@"Done" forState:UIControlStateSelected];
  return button;
}

+ (UIButton *)ringButtonWithText:(NSString *)text
{
  UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
  _button.frame = CGRectMake(10, 2, 60, 40);
  [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_button setTitle:text forState:UIControlStateNormal];
  _button.titleLabel.font = [UIFont boldRingFontOfSize:14];
  return _button;
}

+ (UIButton *)nextButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 18, 24);
  [button setImage:[UIImage imageNamed:@"next-btn"] forState:UIControlStateNormal];
  return button;
}

+ (UIButton *)circleButton
{
  UIButton *_editButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _editButton.frame = CGRectMake(10, 2, 33, 33);
  [_editButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
  _editButton.titleLabel.font = [UIFont boldRingFontOfSize:12];
  return _editButton;
}

- (void)flatButtonWithGreenColor
{
  [self setBackgroundImage:[UIImage ringGreenButton] forState:UIControlStateNormal];
  [self setBackgroundImage:[UIImage ringdarkGreenButton] forState:UIControlStateHighlighted];
  self.titleLabel.font = [UIFont boldRingFontOfSize:14];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
@end
