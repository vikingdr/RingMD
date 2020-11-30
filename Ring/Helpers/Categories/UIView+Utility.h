//
//  UIView+Utility.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)
- (void)shadowTop;
- (void)decorateCircle;
- (void)decorateCircleWithBorder:(CGFloat)border;
- (void)decorateEclipseWithRadius:(CGFloat)border;
- (void)decorateCircleWithBorder:(CGFloat)border andColor:(UIColor *)color;
- (void)shadowBottomRight;
- (void)decorateBorder:(CGFloat)border andColor:(UIColor *)color;
@end
