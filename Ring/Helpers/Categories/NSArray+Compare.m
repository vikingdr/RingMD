//
//  NSArray+Compare.m
//  Ring
//
//  Created by Medpats on 4/22/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "NSArray+Compare.h"

@implementation NSArray (Compare)
- (BOOL)containsNumber:(NSNumber *)number
{
  return CFArrayContainsValue ( (__bridge CFArrayRef)self,
                                     CFRangeMake(0, self.count),
                                     (CFNumberRef)number );
}
@end
