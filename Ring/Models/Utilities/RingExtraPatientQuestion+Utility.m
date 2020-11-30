//
//  RingExtraPatientQuestion+Utility.m
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingExtraPatientQuestion+Utility.h"

#import "Ring-Essentials.h"

@implementation RingExtraPatientQuestion (Utility)
+ (RingExtraPatientQuestion *)findById:(NSNumber *)extraPatientQuestionId
{
  return (RingExtraPatientQuestion *)[[RingData sharedInstance] findSingleEntity:@"RingExtraPatientQuestion" withPredicateString:@"extraPatientQuestionId == %@" andArguments:@[extraPatientQuestionId] withSortDescriptionKey:nil];
}

+ (RingExtraPatientQuestion *)insertWithJSON:(NSDictionary *)jsonData
{
  RingExtraPatientQuestion *extraPatientQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"RingExtraPatientQuestion" inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [extraPatientQuestion updateAttributeWithJson:jsonData];
  return extraPatientQuestion;
}

+ (RingExtraPatientQuestion *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingExtraPatientQuestion *extraPatientQuestion = [self findById:[jsonData objectForKey:@"id"]];
  if (extraPatientQuestion)
    [extraPatientQuestion updateAttributeWithJson:jsonData];
  else
    extraPatientQuestion = [RingExtraPatientQuestion insertWithJSON:jsonData];
  
  return extraPatientQuestion;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"question" : @"question", @"type" : @"type"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  self.options = [jsonData objectForKey:@"options"];
}
@end
