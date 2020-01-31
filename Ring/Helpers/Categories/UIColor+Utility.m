//
//  UIColor+Utility.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)
+ (UIColor *)ringLightOrangeColor
{
  return [UIColor colorWithRed:0.969 green:0.576 blue:0.114 alpha:1];
}

+ (UIColor *)ringLightMainColor
{
  return [UIColor colorWithRed:0.38 green:0.455 blue:0.471 alpha:1];
}

+ (UIColor *)ringOrangeColor
{
  return [UIColor colorWithRed:0.933 green:0.525 blue:0.275 alpha:1];
}

+ (UIColor *)ringBGGrayColor
{
  return [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1];
}

+ (UIColor *)ringWhiteColor
{
  //return [UIColor colorWithRed:0.949 green:0.969 blue:0.973 alpha:1]; // AFAJCT, this was never implemented consistently
  return [UIColor whiteColor];
}

+ (UIColor *)ringOffLineColor
{
  return [UIColor lightGrayColor];
}

+ (UIColor *)ringMainColor
{
  return [UIColor colorWithRed:60.0/255 green:179.0/255 blue:230.0/255 alpha:1];
}

+ (UIColor *)ringNotificationColor
{
  return [self ringOrangeColor];
}

+ (UIColor *)ringNormalGrayColor
{
  return [UIColor colorWithRed:0.875 green:0.902 blue:0.906 alpha:1];
}

+ (UIColor *)ringDarkGrayColor
{
  return [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
}

+ (UIColor *)ringLightGrayColor
{
  return [UIColor colorWithRed:0.925 green:0.929 blue:0.929 alpha:1];
}

+ (UIColor *)ringBackgroundMenuColor
{
  return [UIColor colorWithRed:0.102 green:0.141 blue:0.18 alpha:1];
}

+ (UIColor *)ring70DarkGrayBGColor
{
  return [UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:0.7];
}

+ (UIColor *)ringDarkGrayBGColor
{
  return [UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1];
}
@end
