//
//  NSString+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/11/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "NSString+Utility.h"

#import "Ring-Essentials.h"

@implementation NSString (Utility)
- (BOOL)isUnsignedInteger
{
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[1-9][0-9]*$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
  assert(error == NULL);
  
  return match != nil;
}

- (BOOL)isNumberPhone
{
  NSString *phoneRegex = @"[0-9]{3}[0-9]{6,12}";
  NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
  return [test evaluateWithObject:self];
}

- (NSString *)convertHTMLInline
{
  NSString *result = [self stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
  result = [result stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
  result = [result stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
  return result;
}

- (NSString *)convertHTML
{
  NSString *result = [self stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
  result = [result stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
  result = [result stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
  result = [result stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
  result = [result stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
  return result;
}

- (BOOL)isEmpty
{
  NSString *text =  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  return [text isEqualToString:@""];
}

- (BOOL)validateEmail
{
  NSString *emailRegex = @"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}";
  NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [test evaluateWithObject:self];
}

- (NSNumber *)getMoney
{
  NSString *text = [self stringByReplacingOccurrencesOfString:@"$" withString:@""];
  return @([text integerValue]);
}

- (NSString*)truncateWithLegnth:(NSInteger )maxLength
{
  NSRange stringRange = {0, MIN([self length], maxLength)};
  
  stringRange = [self rangeOfComposedCharacterSequencesForRange:stringRange];
  
  return [self substringWithRange:stringRange];
}

- (NSMutableAttributedString *)attributedStringByBoldInRange:(NSRange)range foregroundColor:(UIColor *)foregroundColor fontSize:(NSInteger)fontSize
{
  UIFont *fontNormal = [UIFont ringFontOfSize:fontSize];
  UIFont *fontBold = [UIFont boldRingFontOfSize:fontSize];
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self];
  [text addAttribute:NSFontAttributeName value:fontNormal range:NSMakeRange(0, text.length)];
  [text addAttribute:NSFontAttributeName value:fontBold range:range];
  [text addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, text.length)];
  return text;
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font1 color:(UIColor *)color1 inRange:(NSRange)range andFont:(UIFont *)font2 color:(UIColor *)color2
{
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self];
  [text addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(0, text.length)];
  [text addAttribute:NSFontAttributeName value:font1 range:range];
  [text addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0, text.length)];
  [text addAttribute:NSForegroundColorAttributeName value:color1 range:range];
  return text;
}

- (NSAttributedString *)attributedHTMLContent
{
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
  return attributedString;
}

@end
