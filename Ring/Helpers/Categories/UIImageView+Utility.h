//
//  UIImageView+Utility.h
//  quizlet
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utility)
- (void)loadImageResizeToFitFromUrl:(NSURL *)url placeholder:(UIImage *)image;
- (void)loadImageFromUrl:(NSURL *)url placeholder:(UIImage *)image;
- (void)loadImageFromUrl:(NSURL *)url;
@end
