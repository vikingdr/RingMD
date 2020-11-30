//
//  UITextView+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/9/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "UILabel+Utility.h"

#import "Ring-Essentials.h"

@implementation UILabel (Utility)
- (void)autoSizeHeight
{
  CGRect newFrame = self.frame;
  newFrame.size.height = [UILabel heightOftext:self.text andFont:self.font];
  self.frame = newFrame;
}

- (CGFloat)minWithCurrentHeight
{
  CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, self.frame.size.height);
  
  NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
  paragraphStyle.alignment = NSTextAlignmentLeft;
  
  CGSize expectedLabelSize = [self.text boundingRectWithSize:maximumLabelSize
                                                     options:NSStringDrawingUsesFontLeading
                              |NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle}
                                                     context:nil].size;
  return expectedLabelSize.width;
}

- (CGFloat)autoSizeHeightWithCurrentWidth
{
  CGRect newFrame = self.frame;
  newFrame.size.height = [UILabel heightOftext:self.text font:self.font andWidth:newFrame.size.width];
  self.frame = newFrame;
  return newFrame.size.height;
}

+ (NSInteger)heightOftext:(NSString *)text andFont:(UIFont *)font
{
  NSInteger width = [RingUtility isIPad] ? 590 : 280;
  return [self heightOftext:text font:font andWidth:width];
}

+ (NSInteger)heightOftext:(NSString *)text font:(UIFont *)font andWidth:(NSInteger)width
{
  CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
  
  NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  paragraphStyle.alignment = NSTextAlignmentLeft;
  
  CGSize expectedLabelSize = [text boundingRectWithSize:maximumLabelSize
                                                options:NSStringDrawingUsesFontLeading
                              |NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle}
                                                context:nil].size;
  
  return expectedLabelSize.height;
}

- (void)decorateTitle
{
  self.backgroundColor = [UIColor ringOrangeColor];
  self.textColor = [UIColor whiteColor];
  self.textAlignment = NSTextAlignmentCenter;
  self.font = [UIFont ringFontOfSize:16];
}
@end
