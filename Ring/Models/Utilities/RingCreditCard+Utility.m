//
//  RingCreditCard+Utility.m
//  Ring
//
//  Created by Medpats on 12/6/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingCreditCard+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

@implementation RingCreditCard (Utility)
+ (RingCreditCard *)createEmpty
{
  return [NSEntityDescription
          insertNewObjectForEntityForName:@"RingCreditCard"
          inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
}

+ (RingCreditCard *)insertWithJSON:(NSDictionary *)jsonData
{
  RingCreditCard *creditCard = [RingCreditCard createEmpty];
  if (jsonData)
    [creditCard updateAttributeWithJson:jsonData];
  return creditCard;
}

+ (RingCreditCard *)findById:(NSNumber *)creditCardId
{
  return (RingCreditCard *)[[RingData sharedInstance] findSingleEntity:@"RingCreditCard" withPredicateString:@"creditCardId == %@" andArguments:@[creditCardId] withSortDescriptionKey:nil];
}

+ (RingCreditCard *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key
{
  RingCreditCard *creditCard = [self findById:[jsonData objectForKey:key]];
  NSNumber *creditCardId = @([[jsonData objectForKey:key] integerValue]);
  NSMutableDictionary *removedIdJson = [jsonData mutableCopy];
  [removedIdJson removeObjectForKey:key];
  if (creditCard)
    [creditCard updateAttributeWithJson:removedIdJson];
  else {
    creditCard = [RingCreditCard insertWithJSON:removedIdJson];
    creditCard.creditCardId = creditCardId;
  }
  
  return creditCard;
}

+ (RingCreditCard *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  return [self insertOrUpdateWithJSON:jsonData withIdKey:@"id"];
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *creditCardJson in jsonArray) {
      [results addObject:[RingCreditCard insertOrUpdateWithJSON:creditCardJson]];
    }
  }
  return results;
}

- (NSString *)shortInfo
{
  NSString *number = self.showNumber ? self.showNumber : [self.number substringFromIndex:[self.number length] - 4];
  
  return [NSString stringWithFormat:@"#%@ - %@", number, self.holder];
}

- (NSString *)expireAt
{
  return [NSString stringWithFormat:@"%@\\%@", self.expireMonth, self.expireYear];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"showNumber": @"number", @"expireYear": @"year", @"expireMonth" : @"month", @"holder": @"holder_name", @"creditCardId": @"id", @"memberId": @"member_id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

+ (void)loadAllWithSuccess:(void(^)(NSArray * cards))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:creditCardTokensPath];
  [operation perform:^(NSArray *json) {
    if(successBlock)
      successBlock([self insertOrUpdateWithJSONArray:json]);
  } modally:YES];
}

- (NSString *)method
{
  if ([[self.number substringToIndex:1] integerValue] == 4) {
    return @"VISA";
  }
  return @"Master";
}

- (BOOL)validateFields
{
  if (!self.number || [self.expireYear isEqualToNumber:@(0)]   || [self.expireMonth isEqualToNumber:@(0)] || !self.holder || !self.code) {
    [UIViewController showMessage:@"Please fill in all fields" withTitle:@"Form data invalid"];
    return false;
  }
  return true;
}

- (NSDictionary *)toParameters
{
  NSString *month = [NSString stringWithFormat:@"0%@", self.expireMonth];
  month = [month substringFromIndex:[month length] - 2];
  return @{@"month": month, @"year": self.expireYear, @"number": self.number, @"holder_name": self.holder, @"verification_value": self.code};
}

- (void)addCardWithSuccess:(void(^)(void))successBlock
{
  if (![self validateFields]) {
    return;
  }
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"credit_card_token": [self toParameters]} path:creditCardTokensPath];
  [operation perform:^(NSDictionary *json) {
    if ([RingNetworkHelper hasError:(json)]) {
      return;
    }
    if(successBlock)
      successBlock();
  } modally:YES];
}

+ (void)deleteCard:(RingCreditCard *)card andSuccess:(void(^)(void))successBlock {
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"DELETE" params:@{} path:[NSString stringWithFormat:memberCreditCardTokensPath, card.creditCardId]];
  [operation perform:^(id json) {
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (void)generateTokenCardForRequest:(RingCallRequest *)callRequest WithSuccess:(void(^)(NSString *token))successBlock {
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"order_id": callRequest.callRequestId, @"currency" : callRequest.currency} path:[NSString stringWithFormat:creditCardGenerateTokenPath, self.creditCardId]];
  [operation perform:^(NSDictionary *json) {
    if ([RingNetworkHelper hasError:(json)]) {
      return;
    }
    if(successBlock)
      successBlock([json objectForKey:@"token"]);
  } modally:YES];
}
@end
