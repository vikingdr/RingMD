//
//  RingSpeciality+Utility.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "RingSpeciality+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingSpeciality (Utility)
+ (NSArray *)all
{
  NSArray * specilities = [[RingData sharedInstance] findEntities:@"RingSpeciality" withPredicateString:nil andArguments:nil withSortDescriptionKeys:@{@"name": @YES}];
  return specilities;
}

+ (NSArray *)allNonEmpty
{
  NSArray * specilities = [[RingData sharedInstance] findEntities:@"RingSpeciality" withPredicateString:@"numDoctors > 0" andArguments:nil withSortDescriptionKeys:@{@"name": @YES}];
  return specilities;
}

+ (RingSpeciality *)findById:(NSNumber *)specialityId
{
  return (RingSpeciality *)[[RingData sharedInstance] findSingleEntity:@"RingSpeciality" withPredicateString:@"specialityId == %@" andArguments:@[specialityId] withSortDescriptionKey:nil];
}

+ (RingSpeciality *)insertWithJSON:(NSDictionary *)jsonData
{
  RingSpeciality *speciality = [NSEntityDescription insertNewObjectForEntityForName:@"RingSpeciality" inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [speciality updateAttributeWithJson:jsonData];
  return speciality;
}

+ (RingSpeciality *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingSpeciality *speciality = [self findById:[jsonData objectForKey:@"id"]];
  if (speciality)
    [speciality updateAttributeWithJson:jsonData];
  else
    speciality = [RingSpeciality insertWithJSON:jsonData];
  
  return speciality;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *specialityJson in jsonArray) {
      [results addObject:[RingSpeciality insertOrUpdateWithJSON:specialityJson]];
    }
  }
  return [results copy];
}

+ (NSArray *)allParents
{
  return [[self all] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentId = %@" argumentArray:@[@(0)]]];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"name" : @"name", @"displayName" : @"display_name", @"specialityId": @"id", @"parentId": @"parent_id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  id parentId = [jsonData objectForKey:@"parent_id"];
  if (parentId && ![parentId isEqual:[NSNull null]]) {
    self.parent = [RingSpeciality insertOrUpdateWithJSON:@{@"id" : parentId}];
  }
  self.numDoctors = @([[jsonData objectForKey:@"count"] intValue]);
  self.image = [RingUtility fullUrlString:[jsonData objectForKey:@"image"]];
}

+ (void)pullSpecialitiesWithSuccess:(void(^)(NSArray *))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:specialitiesPath];
  [operation perform:^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } modally:[RingSpeciality all].count == 0];
}

- (void)loadSpecialistsWithSuccessBlock:(void(^)(NSArray *))successBlock page:(NSInteger)page
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"page": @(page), @"search_by": @"type", @"keyword" : self.specialityId, @"per_page": @(perPage)} path:doctorsPath];
  [operation perform:^(NSArray *json) {
    NSArray *newDoctors = [RingUser insertOrUpdateWithJSONArray:json];
    
    NSMutableArray *doctors = [[self.doctors array] mutableCopy];
    [doctors addObjectsFromArray:newDoctors];
    self.doctors = [NSOrderedSet orderedSetWithArray:doctors];
    
    successBlock(newDoctors);
  } modally:page == 1];
}
@end
