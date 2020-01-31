//
//  UIImage+Utility.h
//  quizlet
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
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
