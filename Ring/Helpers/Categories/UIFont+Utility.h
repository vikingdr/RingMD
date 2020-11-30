//
//  UIFont+Utility.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RingConfigConstant;

@interface UIFont (Utility)
+ (UIFont *)boldRingFontOfSize:(CGFloat)fontSize;
+ (UIFont *)ringFontOfSize:(CGFloat)fontSize;
+ (UIFont *)mediumRingFontOfSize:(CGFloat)fontSize;
+ (RingConfigConstant *)ringFontSizes;
@end
