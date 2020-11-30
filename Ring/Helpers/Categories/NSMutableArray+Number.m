//
//  NSMutableArray+Number.m
//  Ring
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "NSMutableArray+Number.h"

#import "NSArray+Compare.h"

@implementation NSMutableArray (Number)
- (void)removeNumber:(NSNumber *)removeNumber
{
  for (NSNumber *number in self) {
    if ([number isEqual:[NSNull null]]) {
      continue;
    }
    if ([number isEqualToNumber:removeNumber]) {
      [self removeObject:number];
      break;
    }
  }
}

- (void)removeString:(NSString *)removeNumber
{
  for (NSString *number in self) {
    if ([number isEqual:[NSNull null]]) {
      continue;
    }
    if ([number isEqualToString:removeNumber]) {
      [self removeObject:number];
      break;
    }
  }
}

- (void)addNumber:(NSNumber *)number
{
  assert(number != nil);
  if (![self containsNumber:number]) {
    [self addObject:number];
  }
}
@end
