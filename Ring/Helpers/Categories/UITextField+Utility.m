//
//  UITextField+Utility.m
//  Ring
//
//  Created by Medpats on 6/17/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "UITextField+Utility.h"

#import "NSString+Utility.h"

@implementation UITextField (Utility)
- (BOOL)isEmtpy
{
  if (self.text == nil) {
    return YES;
  }
  return [self.text isEmpty];
}
@end
