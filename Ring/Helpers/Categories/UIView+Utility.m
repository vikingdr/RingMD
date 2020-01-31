//
//  UIView+Utility.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "UIView+Utility.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utility)
- (void)shadowTop
{
  self.layer.masksToBounds = NO;
  self.layer.shadowOffset = CGSizeMake(0, -1);
  self.layer.shadowRadius = 2;
  self.layer.shadowOpacity = 0.5;
  self.layer.shadowColor = [UIColor grayColor].CGColor;
}

- (void)decorateCircle
{
  [self decorateCircleWithBorder:0];
}

- (void)decorateCircleWithBorder:(CGFloat)border
{
  [self decorateCircleWithBorder:border andColor:[UIColor whiteColor]];
}

- (void)decorateCircleWithBorder:(CGFloat)border andColor:(UIColor *)color
{
  [self.layer setCornerRadius:self.frame.size.height / 2];
  [self.layer setBorderWidth:border];
  [self.layer setBorderColor:color.CGColor];
  [self.layer setMasksToBounds:YES];
}

- (void)decorateBorder:(CGFloat)border andColor:(UIColor *)color
{
  [self.layer setBorderWidth:border];
  [self.layer setBorderColor:color.CGColor];
  [self.layer setMasksToBounds:YES];
}

- (void)decorateEclipseWithRadius:(CGFloat)radius
{
  [self.layer setCornerRadius:radius];
  [self.layer setBorderWidth:0];
  [self.layer setMasksToBounds:YES];
}

- (void)shadowBottomRight
{
  self.layer.masksToBounds = NO;
  self.layer.shadowOffset = CGSizeMake(1, 1);
  self.layer.shadowRadius = 2;
  self.layer.shadowOpacity = 0.5;
  self.layer.shadowColor = [UIColor grayColor].CGColor;
}
@end
