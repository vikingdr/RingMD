//
//  UIFont+Utility.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "UIFont+Utility.h"

#import "RingConfigConstant.h"

@implementation UIFont (Utility)
+ (UIFont *)boldRingFontOfSize:(CGFloat)fontSize
{
  return [UIFont fontWithName:@"TeXGyreAdventor-Bold" size:fontSize];
}

+ (UIFont *)mediumRingFontOfSize:(CGFloat)fontSize
{
 return [UIFont fontWithName:@"TeXGyreAdventor-Italic" size:fontSize];
}

+ (UIFont *)ringFontOfSize:(CGFloat)fontSize
{
  return [UIFont fontWithName:@"TeXGyreAdventor-Regular" size:fontSize];
}

+ (UIFont *)lightRingFontOfSize:(CGFloat)fontSize
{
  return [UIFont fontWithName:@"TeXGyreAdventor-Italic" size:fontSize];
}

+ (RingConfigConstant *)ringFontSizes
{
  return [RingConfigConstant sharedInstance];
}
@end
