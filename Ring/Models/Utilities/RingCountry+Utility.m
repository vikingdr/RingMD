//
//  RingCountry+Utility.m
//  Ring
//
//  Created by Medpats on 3/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingCountry+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

@implementation RingCountry (Utility)
+ (NSArray *)all
{
  NSArray * countries = [[RingData sharedInstance] findEntities:@"RingCountry" withPredicateString:nil andArguments:nil withSortDescriptionKeys:@{@"name": @YES}];
  return countries;
}

+ (RingCountry *)insertWithJSON:(NSDictionary *)jsonData
{
  RingCountry *country = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"RingCountry"
                                      inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [country updateAttributeWithJson:jsonData];
  return country;
}

+ (RingCountry *)findById:(NSNumber *)countryId
{
  return (RingCountry *)[[RingData sharedInstance] findSingleEntity:@"RingCountry" withPredicateString:@"countryId == %@" andArguments:@[countryId] withSortDescriptionKey:nil];
}

+ (RingCountry *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingCountry *country = [self findById:[jsonData objectForKey:@"id"]];
  if (country)
    [country updateAttributeWithJson:jsonData];
  else
    country = [RingCountry insertWithJSON:jsonData];
  
  return country;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *countryJson in jsonArray) {
      [results addObject:[RingCountry insertOrUpdateWithJSON:countryJson]];
    }
  }
  return [results copy];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"name" : @"name", @"countryId": @"id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

+ (void)pullCountriesWithSuccess:(void(^)(NSArray *))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} fullPath:countriesPath];
  [operation perform:^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } modally:YES];
}
@end
