//
//  UIImageView+Utility.m
//  quizlet
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "UIImageView+Utility.h"

#import "Ring-Essentials.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImageView (Utility)
- (void)loadImageResizeToFitFromUrl:(NSURL *)url placeholder:(UIImage *)image
{
  __block UIImageView *imageView = self;
  [self sd_setImageWithURL:url
          placeholderImage:image
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   if(error) {
                     NSLog(@"Could not download image %@.", url);
                   } else {
                     imageView.image = [image resizeAndCropWithSize:imageView.frame.size];
                   }
                 }];
  self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)loadImageFromUrl:(NSURL *)url placeholder:(UIImage *)image
{
  __block UIImageView *imageView = self;
  [self sd_setImageWithURL:url
          placeholderImage:image
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   if(error) {
                     NSLog(@"Could not download image %@.", url);
                   } else {
                     imageView.image = image;
                   }
                 }];
  self.contentMode = (UIViewContentModeScaleAspectFit);
  self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (void)loadImageFromUrl:(NSURL *)url {
  [self loadImageFromUrl:url placeholder:[UIImage imageNamed:@"icon"]];
}

//- (void)loadImageFromAssetString:(NSURL *)assetUrl placeholder:(UIImage *)image
//{
//  self.image = image;
//  ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//  [assetLibrary assetForURL:assetUrl resultBlock:^(ALAsset *asset) {
//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    CGImageRef iref = [rep fullResolutionImage];
//    if (iref) {
//      self.image = [UIImage imageWithCGImage:iref];
//    }
//  } failureBlock:^(NSError *err) {
//    NSLog(@"Error: %@",[err localizedDescription]);
//  }];
//}
@end
