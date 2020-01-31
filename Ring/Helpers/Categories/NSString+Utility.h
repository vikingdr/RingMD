//
//  NSString+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/11/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
- (BOOL)isUnsignedInteger;
- (BOOL)isNumberPhone;
- (NSString *)convertHTML;
- (NSString *)convertHTMLInline;
- (BOOL)isEmpty;
- (BOOL)validateEmail;
- (NSNumber *)getMoney;
- (NSString*)truncateWithLegnth:(NSInteger )maxLength;

- (NSMutableAttributedString *)attributedStringByBoldInRange:(NSRange)range foregroundColor:(UIColor *)foregroundColor fontSize:(NSInteger)fontSize;
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font1 color:(UIColor *)color1 inRange:(NSRange)range andFont:(UIFont *)font2 color:(UIColor *)color2;
- (NSAttributedString *)attributedHTMLContent;
@end
