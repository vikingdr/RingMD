//
//  RingCallRequest+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/10/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingCallRequest+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingCallRequest (Utility)
+ (RingCallRequest *)createCallRequest
{
  return [NSEntityDescription insertNewObjectForEntityForName:@"RingCallRequest"
                                       inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  
}
+ (RingCallRequest *)insertWithJSON:(NSDictionary *)jsonData
{
  RingCallRequest *callRequest = [self createCallRequest];
  if (jsonData)
    [callRequest updateAttributeWithJson:jsonData];
  return callRequest;
}

+ (RingCallRequest *)createWithUser:(RingUser *)user
{
  RingCallRequest *callRequest = [self createCallRequest];
  callRequest.receiver = user;
  callRequest.caller = [RingUser currentCacheUser];
  callRequest.numberPhone = callRequest.caller.phoneNumber;
  return callRequest;
}

+ (RingCallRequest *)findById:(NSNumber *)callRequestId
{
  RingCallRequest *callRequest = (RingCallRequest *)[[RingData sharedInstance] findSingleEntity:@"RingCallRequest" withPredicateString:@"callRequestId == %@" andArguments:@[callRequestId] withSortDescriptionKey:nil];
  return callRequest;
}

+ (RingCallRequest *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingCallRequest *callRequest = [self findById:[jsonData objectForKey:@"id"]];
  if (callRequest)
    [callRequest updateAttributeWithJson:jsonData];
  else
    callRequest = [RingCallRequest insertWithJSON:jsonData];
  
  return callRequest;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *callRequestJson in jsonArray) {
      [results addObject:[RingCallRequest insertOrUpdateWithJSON:callRequestJson]];
    }
  }
  return results;
}

- (RingUser *)user
{
  if (IS_DOCTOR)
    return self.caller;
  return self.receiver;
}

- (BOOL)isAccepted
{
  return [self.state isEqualToString:@"accepted"];
}

- (BOOL)isFinished
{
  return [self.state isEqualToString:@"finished"];
}

- (void)setFinished
{
  self.state = @"finished";
}

- (BOOL)isRequested
{
  return [self.state isEqualToString:@"requested"] || [self.state isEqualToString:@"paid"];
}

- (BOOL)canRate
{
  return !self.rate && [self isFinished] && !IS_DOCTOR;
}

- (BOOL)isInProgress
{
  return [self.state isEqualToString:@"in progress"];
}

- (BOOL)isNormalCall
{
  return [self.type isEqualToString:VOICE_CALL];
}

- (void)setGoingFinish
{
  self.state = @"isGoingFinished";
}

- (BOOL)isGoingFinish
{
  return [self.state isEqualToString:@"isGoingFinished"];
}

- (NSDate *)acceptedDate
{
  //  RingTimeSlot *timeSlot = [[[self.timeSlots array] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state == %@" argumentArray:@[@"accepted"]]] lastObject];
  //  return timeSlot.callTime;
  return self.callTime;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"reason" : @"reason", @"state" : @"aasm_state", @"durationEstimate" : @"expected_duration_in_minutes", @"callRequestId" : @"id", @"type" : @"type", @"numberPhone" : @"caller_number", @"doctorJoined" : @"doctor_joined", @"patientJoined" : @"patient_joined", @"currency" : @"patient_currency", @"callTime": @"accepted_call_time"};
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  
  if ([jsonData objectForKey:@"time_slots"]) {
    self.timeSlots = [[NSOrderedSet alloc] initWithArray:[RingTimeSlot insertOrUpdateWithJSONArray:[jsonData objectForKey:@"time_slots"]]];
  }
  if (IS_DOCTOR) {
    self.receiver = [RingUser currentCacheUser];
  } else {
    self.caller = [RingUser currentCacheUser];
  }
  if ([jsonData objectForKey:@"caller"]) {
    self.caller = [RingUser insertOrUpdateWithJSON:[jsonData objectForKey:@"caller"] withIdKey:@"id"];
  }
  
  if ([jsonData objectForKey:@"receiver"]) {
    self.receiver = [RingUser insertOrUpdateWithJSON:[jsonData objectForKey:@"receiver"] withIdKey:@"id"];
  }
}

- (BOOL)canCallNow
{
  if (!self.isAccepted) {
    return NO;
  }
  
  if(self.isNormalCall) {
    NSLog(@"Cannot 'call now' from the app because this is a phone call.");
    return NO;
  }
  
  NSDate *now = [NSDate date];
  NSDate *startTime = [self.callTime dateInNexMinutes:-[RingUtility timeBeforeDisplayCallButton]];
  NSDate *endTime = [self.callTime dateInNexMinutes:[RingUtility timeAfterDisplayCallButton]];
  NSComparisonResult compToStart = [now compare:startTime];
  NSComparisonResult compToEnd = [now compare:endTime];
  
//#ifdef DEBUG
//  NSLog(@"WARNING. TREATING ALL ACCEPTED VIDEO CALLS AS JOINABLE.");
//  return YES;
//#endif
  
  return compToStart != NSOrderedAscending && compToEnd != NSOrderedDescending;
}

- (BOOL)validate
{
  BOOL isValid = self.reason && ![self.reason isEmpty];
  if (!isValid) {
    [UIViewController showMessage:@"Please describe why you want to request a call." withTitle:@"Form data invalid"];
  };
  return isValid;
}

//+ (void)pullCallRequestsWithDate:(NSDate *)date andSuccess:(void(^)(NSArray *callRequests))successBlock
//{
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"full" : @YES, @"from_date" : [[date beginOfDay] ISOString], @"to_date" : [[date endOfDay] ISOString], @"per_page" : @(100)} path:callRequestsPath];
//  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSString *response = [operation responseString];
//    NSArray *json = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
//                                                    options: NSJSONReadingMutableContainers
//                                                      error: nil];
//    [UIViewController hideLoading];
//    if(successBlock)
//      successBlock([self insertOrUpdateWithJSONArray:json]);
//  } failure:[RingUtility operationFailurehandler]];
//  [RingUtility addToOperationToQueue:operation];;
//}

+ (void)loadActiveCallRequestsWithPage:(NSInteger )page andSuccess:(void(^)(NSArray *callRequests))successBlock blockView:(UIView *)blockView
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"filter" : @"active", @"page" : @(page), @"per_page": @(perPage)} path:callRequestsPath];
  [operation perform: ^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } blockView:blockView json:YES numberOfPreviousAttempts:0];
}

+ (void)loadHistoryCallRequestsWithPage:(NSInteger )page andSuccess:(void(^)(NSArray *callRequests))successBlock blockView:(UIView *)blockView
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"filter" : @"history", @"page" : @(page), @"per_page": @(perPage)} path:callRequestsPath];
  [operation perform: ^(NSArray *json) {
    NSArray *result = [self insertOrUpdateWithJSONArray:json];
    if(successBlock)
      successBlock(result);
  } blockView:blockView json:YES numberOfPreviousAttempts:0];
}

//+ (void)loadCallRequestsInDate:(NSDate *)date andSuccess:(void(^)(NSArray *callRequests))successBlock
//{
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"date" : [date dateSubmitServerFormat]} path:requestsInDatePath];
//  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSString *response = [operation responseString];
//    NSArray *json = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
//                                                    options: NSJSONReadingMutableContainers
//                                                      error: nil];
//    [UIViewController hideLoading];
//    if(successBlock)
//      successBlock([self insertOrUpdateWithJSONArray:json]);
//  } failure:[RingUtility operationFailurehandler]];
//  [RingUtility addToOperationToQueue:operation];;
//}

- (void)pullCallRequestDetailWithSuccess:(void(^)(void))successBlock modally:(BOOL)modally
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:[NSString stringWithFormat:requestShowPath, self.callRequestId ]];
  [operation perform:^(NSDictionary *json) {
    [self updateAttributeWithJson:json];
    if(successBlock)
      successBlock();
  } modally:modally];
}

- (void)pullOpenTokChatRoom:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:[NSString stringWithFormat:chatroomVideoCallPath, self.callRequestId ]];
  [operation perform:^(NSDictionary *json) {
    self.openTokSesion = [RingOpenTokSession insertWithJSON:json];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (NSDictionary *)toParammeters
{
  NSMutableDictionary *timeSlots = [NSMutableDictionary dictionary];
  for (NSInteger i = 0; i < [self.timeSlots count]; ++i) {
    RingTimeSlot * timeSlot = [self.timeSlots objectAtIndex:i];
    [timeSlots addEntriesFromDictionary:@{[@(i) stringValue] : @{@"call_time" : [timeSlot.callTime sumbitServerFormat]}}];
  }
  return @{ @"reason": self.reason, @"expected_duration_in_minutes": self.durationEstimate, @"receiver_id" : self.receiver.userId, @"time_slots_attributes": timeSlots, @"caller_number": self.numberPhone, @"type" : self.type };
}

- (void)submitRequest:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"request": [self toParammeters]} path:requestsPath];
  [operation perform:^(NSDictionary *json) {
    [self updateAttributeWithJson:json];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (void)requestFinishedSessionWithSuccess:(void(^)(void))successBlock andFailed:(void(^)(void))failBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{} path:[NSString stringWithFormat:finishSessionRequestPath, self.callRequestId]];
  [operation perform:^(NSDictionary *json) {
    if ([[json objectForKey:@"result"] boolValue]) {
      [self setFinished];
      if (successBlock) {
        successBlock();
      }
    } else {
      failBlock();
    }
  } modally:YES];
}

//- (void)requestStartSessionWithSuccess:(void(^)(void))successBlock
//{
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{} path:[NSString stringWithFormat:startSessionRequestPath, self.callRequestId]];
//  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    [self setFinished];
//    [UIViewController hideLoading];
//    if (successBlock) {
//      successBlock();
//    }
//  } failure:[RingUtility operationFailurehandler]];
//    [RingUtility addToOperationToQueue:operation];;
//}

- (void)cancelRequestWithSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{} path:[NSString stringWithFormat:cancelRequestPath, self.callRequestId]];
  [operation perform:^(id json) {
    if (successBlock) {
      successBlock();
    }
  } modally:YES];
}

- (void)rate:(CGFloat)rate withContent:(NSString *)content andSuccess:(void(^)())successBlock
{
  if (content == nil) {
    content = @"";
  }
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"score" : @(rate), @"content": content} path:[NSString stringWithFormat:doctorRatePath, self.callRequestId]];
  [operation perform:^(id json) {
    if (successBlock) {
      successBlock();
    }
  } modally:YES];
}
@end
