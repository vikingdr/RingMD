//
//  RingMedicalSchool+Utility.m
//  Ring
//
//  Created by Medpats on 3/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingMedicalSchool+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

@implementation RingMedicalSchool (Utility)
+ (NSArray *)all
{
  NSArray * medicalSchools = [[RingData sharedInstance] findEntities:@"RingMedicalSchool" withPredicateString:nil andArguments:nil withSortDescriptionKeys:nil];
  return medicalSchools;
}

+ (RingMedicalSchool *)insertWithJSON:(NSDictionary *)jsonData
{
  RingMedicalSchool *medicalSchool = [NSEntityDescription
                                insertNewObjectForEntityForName:@"RingMedicalSchool"
                                inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [medicalSchool updateAttributeWithJson:jsonData];
  return medicalSchool;
}

+ (RingMedicalSchool *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingMedicalSchool *medicalSchool = (RingMedicalSchool *)[[RingData sharedInstance] findSingleEntity:@"RingMedicalSchool" withPredicateString:@"medicalSchoolId == %@" andArguments:@[[jsonData objectForKey:@"id"]] withSortDescriptionKey:nil];
  if (medicalSchool)
    [medicalSchool updateAttributeWithJson:jsonData];
  else
    medicalSchool = [RingMedicalSchool insertWithJSON:jsonData];
  
  return medicalSchool;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *medicalSchoolJson in jsonArray) {
      [results addObject:[RingMedicalSchool insertOrUpdateWithJSON:medicalSchoolJson]];
    }
  }
  return [results copy];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"name" : @"label", @"medicalSchoolId": @"id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

+ (void)searchMedicalSchoolsWithText:(NSString *)text andSuccess:(void(^)(NSArray *))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"term" : text} fullPath:medicalSchoolsPath];
  [operation perform:^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } modally:NO];
}
@end

