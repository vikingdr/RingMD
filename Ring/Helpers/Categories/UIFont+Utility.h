//
//  UIFont+Utility.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RingConfigConstant;

@interface UIFont (Utility)
+ (UIFont *)boldRingFontOfSize:(CGFloat)fontSize;
+ (UIFont *)ringFontOfSize:(CGFloat)fontSize;
+ (UIFont *)mediumRingFontOfSize:(CGFloat)fontSize;
+ (RingConfigConstant *)ringFontSizes;
@end
