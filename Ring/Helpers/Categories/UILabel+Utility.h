//
//  UITextView+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/9/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utility)
- (void)autoSizeHeight;
- (CGFloat)autoSizeHeightWithCurrentWidth;
- (CGFloat)minWithCurrentHeight;
- (void)decorateTitle;
+ (NSInteger)heightOftext:(NSString *)text andFont:(UIFont *)font;
+ (NSInteger)heightOftext:(NSString *)text font:(UIFont *)font andWidth:(NSInteger)width;
@end
