//
//  RingPatientAnswer+Utility.m
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPatientAnswer+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@implementation RingPatientAnswer (Utility)
+ (RingPatientAnswer *)findById:(NSNumber *)patientAnswerId
{
  return (RingPatientAnswer *)[[RingData sharedInstance] findSingleEntity:@"RingPatientAnswer" withPredicateString:@"patientAnswerId == %@" andArguments:@[patientAnswerId] withSortDescriptionKey:nil];
}

+ (RingPatientAnswer *)createEmpty
{
  return [NSEntityDescription insertNewObjectForEntityForName:@"RingPatientAnswer" inManagedObjectContext:[RingData sharedInstance].managedObjectContext];;
}

+ (RingPatientAnswer *)insertWithJSON:(NSDictionary *)jsonData
{
  RingPatientAnswer *patientAnswer = [self createEmpty];
  if (jsonData)
    [patientAnswer updateAttributeWithJson:jsonData];
  return patientAnswer;
}

+ (RingPatientAnswer *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingPatientAnswer *patientAnswer = [self findById:[jsonData objectForKey:@"id"]];
  if (patientAnswer)
    [patientAnswer updateAttributeWithJson:jsonData];
  else
    patientAnswer = [RingPatientAnswer insertWithJSON:jsonData];
  
  return patientAnswer;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *patientQuestionJson in jsonArray) {
      [results addObject:[RingPatientAnswer insertOrUpdateWithJSON:patientQuestionJson]];
    }
  }
  return [results copy];
}

+ (RingPatientAnswer *)findByPatientQuestionId:(NSNumber *)questionId forUser:(RingUser *)user
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"patientQuestionId = %@" argumentArray:@[questionId]];
  NSSet *anwsers = [user.patientAnswers filteredSetUsingPredicate:predicate];
  if ([anwsers count] > 0) {
    return [anwsers anyObject];
  }
  return nil;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"patientQuestionId" : @"patient_question_id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  if ([jsonData objectForKey:@"answer"]) {
    self.value = [jsonData valueForKeyPath:@"answer.value"];
    if ([[jsonData valueForKeyPath:@"answer.extra_answer"] isKindOfClass:[NSString class]]) {
      self.answer = [jsonData valueForKeyPath:@"answer.extra_answer"];
    }
  }
}
@end
