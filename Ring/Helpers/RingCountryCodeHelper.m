//
//  RingCountryCodeHelper.m
//  Ring
//
//  Created by Medpats on 5/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingCountryCodeHelper.h"

@interface RingCountryCodeHelper()
@property (strong, nonatomic) NSDictionary *countryMap;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *sortedValues;
@end

@implementation RingCountryCodeHelper
- (id)init
{
  self = [super init];
  if (self) {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-Code"
                                                          ofType:@"plist"];
    _countryMap = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
  }
  return self;
}

- (NSArray *)sortedKeys
{
  if (!_sortedKeys) {
    _sortedKeys = [self.countryMap keysSortedByValueUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
      return [obj1 compare:obj2];
    }];
  }
  return _sortedKeys;
}

- (NSArray *)sortedValues
{
  if (!_sortedValues) {
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *key in self.sortedKeys)
      [values addObject: [self.countryMap objectForKey: key]];
    _sortedValues = [values copy];
  }
  return _sortedValues;
}

+ (RingCountryCodeHelper *)sharedInstance
{
  static dispatch_once_t p = 0;
  __strong static id _sharedObject = nil;
  
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

- (NSArray *)allCodes
{
  return self.sortedKeys;
}

- (NSArray *)allCountries
{
  return self.sortedValues;
}
@end
