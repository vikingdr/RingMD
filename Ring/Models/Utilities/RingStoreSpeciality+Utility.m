//
//  RingStoreSpeciality+Utility.m
//  Ring
//
//  Created by Medpats on 12/4/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingStoreSpeciality+Utility.h"

#import "Ring-Essentials.h"

@implementation RingStoreSpeciality (Utility)
+ (NSArray *)all
{
  NSArray * specilities = [[RingData sharedInstance] findEntities:@"RingStoreSpeciality" withPredicateString:nil andArguments:nil withSortDescriptionKeys:nil];
  return specilities;
}

+ (RingStoreSpeciality *)insertWithJSON:(NSDictionary *)jsonData
{
  RingStoreSpeciality *speciality = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"RingStoreSpeciality"
                                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [speciality updateAttributeWithJson:jsonData];
  return speciality;
}

+ (RingStoreSpeciality *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingStoreSpeciality *speciality = (RingStoreSpeciality *)[[RingData sharedInstance] findSingleEntity:@"RingStoreSpeciality" withPredicateString:@"specialityId == %@" andArguments:@[[jsonData objectForKey:@"id"]] withSortDescriptionKey:nil];
  if (speciality)
    [speciality updateAttributeWithJson:jsonData];
  else
    speciality = [RingStoreSpeciality insertWithJSON:jsonData];
  
  return speciality;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *specialityJson in jsonArray) {
      [results addObject:[RingStoreSpeciality insertOrUpdateWithJSON:specialityJson]];
    }
  }
  [[RingData sharedInstance] saveContext];
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"name" : @"name", @"specialityId": @"id", @"image" : @"image"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  self.numDoctors = @([[jsonData objectForKey:@"count"] intValue]);
}
@end
