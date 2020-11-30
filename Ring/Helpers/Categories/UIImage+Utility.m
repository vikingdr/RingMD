//
//  UIImage+Utility.m
//  quizlet
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "UIImage+Utility.h"

#import "Ring-Essentials.h"

@implementation UIImage (Utility)

- (UIImage *)resizePhotoWithNewWidth:(CGFloat)width {
  CGSize newSize = CGSizeMake(width, self.size.height / self.size.width * width);
  UIGraphicsBeginImageContext(newSize);
  [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)resizePhotoWithNewHeight:(CGFloat)height {
  CGSize newSize = CGSizeMake(self.size.width / self.size.height * height, height);
  UIGraphicsBeginImageContext(newSize);
  [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)cropWithRect:(CGRect)cropRect {
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
  UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  return cropImage;
}

- (UIImage *)resizeAndCropWithSize:(CGSize)cropSize {
  if (cropSize.width > cropSize.height)
  {
    if (self.size.width > self.size.height)
    {
      return [[self resizePhotoWithNewHeight:cropSize.height] cropWithRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    }
    else
    {
      return [[self resizePhotoWithNewWidth:cropSize.width] cropWithRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    }
  }
  else
  {
    if (self.size.width > self.size.height)
    {
      return [[self resizePhotoWithNewHeight:cropSize.width] cropWithRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    }
    else
    {
      return [[self resizePhotoWithNewWidth:cropSize.height] cropWithRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    }
  }
}

- (UIImage *)resizeWithToUpLoad
{
  if (self.size.width > [RingUtility currentWidth]) {
    return [self resizePhotoWithNewWidth:[RingUtility currentWidth]];
  }
  return self;
}

- (UIImage *)resizeToUploadAvatar
{
  return [self resizeWithNewSize:CGSizeMake(100, 100)];
}

- (UIImage *)resizeWithNewSize:(CGSize)newSize {
  UIGraphicsBeginImageContext(newSize);
  [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+ (UIImage *)ringGreenButton
{
  return [[UIImage imageNamed:@"green-pattern"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage *)ringdarkGreenButton
{
  return [[UIImage imageNamed:@"green-pattern"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage *)ringGrayButton
{
  return [[UIImage imageNamed:@"gray-pattern"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage *)ringYellowButton
{
  return [[UIImage imageNamed:@"yellow-pattern"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}
@end

