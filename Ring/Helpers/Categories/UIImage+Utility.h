//
//  UIImage+Utility.h
//  quizlet
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)
- (UIImage *)resizePhotoWithNewWidth:(CGFloat)width;
- (UIImage *)resizePhotoWithNewHeight:(CGFloat)height;
- (UIImage *)cropWithRect:(CGRect)cropRect;
- (UIImage *)resizeAndCropWithSize:(CGSize)cropSize;
- (UIImage *)resizeWithNewSize:(CGSize)newSize;
- (UIImage *)resizeWithToUpLoad;
- (UIImage *)resizeToUploadAvatar;
+ (UIImage *)ringGreenButton;
+ (UIImage *)ringdarkGreenButton;
+ (UIImage *)ringGrayButton;
+ (UIImage *)ringYellowButton;
@end
