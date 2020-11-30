//
//  RingPatientQuestion+Utility.m
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingPatientQuestion+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingPatientQuestion (Utility)
+ (NSArray *)all
{
  NSArray * patientQuestions = [[RingData sharedInstance] findEntities:@"RingPatientQuestion" withPredicateString:nil andArguments:nil withSortDescriptionKeys:nil];
  return patientQuestions;
}

+ (NSArray *)getByType:(NSString *)type
{
  NSArray * patientQuestions = [[RingData sharedInstance] findEntities:@"RingPatientQuestion" withPredicateString:@"type = %@" andArguments:@[type] withSortDescriptionKeys:@{@"patientQuestionId": @(YES)}];
  return patientQuestions;
}

+ (RingPatientQuestion *)findById:(NSNumber *)patientQuestionId
{
  return (RingPatientQuestion *)[[RingData sharedInstance] findSingleEntity:@"RingPatientQuestion" withPredicateString:@"patientQuestionId == %@" andArguments:@[patientQuestionId] withSortDescriptionKey:nil];
}

+ (RingPatientQuestion *)insertWithJSON:(NSDictionary *)jsonData
{
  RingPatientQuestion *patientQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"RingPatientQuestion" inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [patientQuestion updateAttributeWithJson:jsonData];
  return patientQuestion;
}

+ (RingPatientQuestion *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingPatientQuestion *patientQuestion = [self findById:[jsonData objectForKey:@"id"]];
  if (patientQuestion)
    [patientQuestion updateAttributeWithJson:jsonData];
  else
    patientQuestion = [RingPatientQuestion insertWithJSON:jsonData];
  
  return patientQuestion;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *patientQuestionJson in jsonArray) {
      [results addObject:[RingPatientQuestion insertOrUpdateWithJSON:patientQuestionJson]];
    }
  }
  return [results copy];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"question" : @"question", @"type" : @"type", @"patientQuestionId": @"id"};

  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  
  if ([jsonData objectForKey:@"extra_info"] && ![[jsonData objectForKey:@"extra_info"] isEqual:[NSNull null]]) {
    self.extraQuestion = [RingExtraPatientQuestion findById:self.patientQuestionId];
    if (self.extraQuestion) {
      [self.extraQuestion updateAttributeWithJson:[jsonData objectForKey:@"extra_info"]];
    } else {
      self.extraQuestion = [RingExtraPatientQuestion insertWithJSON:[jsonData objectForKey:@"extra_info"]];
      self.extraQuestion.extraPatientQuestionId = self.patientQuestionId;
    }
  }
}

+ (void)loadAllSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:patientQuestionPath];
  [operation perform:^(NSArray *json) {
    [self insertOrUpdateWithJSONArray:json];
    NSArray *currentTreatmentQuesitons = @[@{@"type": @"CurrentPatientQuestion", @"question": @"What are your current symptoms?", @"id":  @(SYMPTOMS_QUESTION), @"extra_info" : @{@"type": @"text_area"}}, @{@"type": @"CurrentPatientQuestion", @"question": @"Are you on any medical treatment?", @"id":  @(TREATMENT_QUESTION), @"extra_info" : @{@"type": @"text_area"}}];
    
    [self insertOrUpdateWithJSONArray:(id)currentTreatmentQuesitons];
    if (successBlock)
      successBlock();
  } modally:YES];
}
@end
