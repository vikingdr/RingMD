//
//  UIImageView+Utility.h
//  quizlet
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utility)
- (void)loadImageResizeToFitFromUrl:(NSURL *)url placeholder:(UIImage *)image;
- (void)loadImageFromUrl:(NSURL *)url placeholder:(UIImage *)image;
- (void)loadImageFromUrl:(NSURL *)url;
@end
