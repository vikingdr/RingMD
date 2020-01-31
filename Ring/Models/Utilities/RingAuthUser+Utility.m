//
//  RingAuthUser+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/9/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingAttachFile+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingPusher.h"
#import "RingConversation.h"
#import "RingMessage.h"
#import "NSArray+Compare.h"
#import "NSMutableArray+Number.h"

@implementation RingAuthUser (Utility)
+ (RingAuthUser *)createEmptyUser {
  return [NSEntityDescription
          insertNewObjectForEntityForName:@"RingAuthUser"
          inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
}

+ (RingAuthUser *)insertWithJSON:(NSDictionary *)jsonData
{
  RingAuthUser *user = [self createEmptyUser];
  if (jsonData)
    [user updateAttributeWithJson:jsonData];
  return user;
}

+ (RingAuthUser *)firstUser
{
  RingAuthUser *user = (RingAuthUser *)[[RingData sharedInstance] findSingleEntity:@"RingAuthUser" withPredicateString:nil andArguments:nil withSortDescriptionKey:nil];
  return user;
}

+ (RingAuthUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingAuthUser *user = (RingAuthUser *)[[RingData sharedInstance] findSingleEntity:@"RingAuthUser" withPredicateString:@"userId == %@" andArguments:@[[jsonData objectForKey:@"id"]] withSortDescriptionKey:nil];
  if (user)
    [user updateAttributeWithJson:jsonData];
  else
    user = [RingAuthUser insertWithJSON:jsonData];
  
  [RingUser insertOrUpdateWithJSON:jsonData withIdKey:@"id"];
  
  return user;
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *userJson in jsonArray) {
      [results addObject:[RingAuthUser insertOrUpdateWithJSON:userJson]];
    }
  }
  return results;
}

- (UIImage *)avatarImage
{
  return [UIImage imageWithData:[NSData dataWithContentsOfURL:[self avatarUrl]]];
}

- (NSURL *)avatarUrl
{
  return [NSURL URLWithString:self.avatar];
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"name" : @"full_name", @"authToken": @"authentication_token", @"userId" : @"id",
                            @"pricePerMinute" : @"price_per_minute", @"location" : @"location", @"about" : @"about", @"email" : @"email", @"phoneCode": @"phone_code", @"phoneRawNumber" : @"phone_raw_number"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  if ([jsonData objectForKey:@"role"] && [[jsonData objectForKey:@"role"] isEqualToString:@"doctor"]) {
    self.isDoctor = @YES;
  } else {
    self.isDoctor = @NO;
  }
  NSString *avatar = [jsonData objectForKey:@"avatar"];
  if (avatar) {
    self.avatar = [RingUtility fullUrlString:avatar];
  }
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password andSuccess:(void(^)(void))successBlock
{ 
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"email": email, @"password": password} path:loginPath];
  
  [operation perform:^(NSDictionary *json) {
    currentUser = [self insertOrUpdateWithJSON:json];
    [[RingData sharedInstance] saveContext];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (BOOL)validateFields
{
  if (![self.email validateEmail]) {
    [UIViewController showMessage:@"Please enter your email address" withTitle:@"Form data invalid"];
    return NO;
  } else if (self.name == nil || [self.name isEmpty]) {
    [UIViewController showMessage:@"Please enter your name." withTitle:@"Form data invalid"];
    return NO;
  } else if (self.name.length > 100) {
    [UIViewController showMessage:@"Please enter a name shorter than 100 characters." withTitle:@"Form data invalid"];
    return NO;
  } else if (self.password == nil || [self.password isEmpty]) {
    [UIViewController showMessage:@"Please enter a password" withTitle:@"Form data invalid"];
    return NO;
  } else if (self.password.length > 100) {
    [UIViewController showMessage:@"Please enter a password shorter than 100 characters." withTitle:@"Form data invalid"];
    return NO;
  } else if (self.phoneCode == nil || [self.phoneCode isEmpty]
             || self.phoneRawNumber == nil || [self.phoneRawNumber isEmpty]) {
    [UIViewController showMessage:@"Please enter your phone number." withTitle:@"Form data invalid"];
    return NO;
  }
  return YES;
}

- (BOOL)validateDoctorFields
{
  BOOL validateOk = YES;
  //  if (self.licenseNumber == nil || [self.licenseNumber isEmpty]) {
  //    [UIViewController showMessage:@"Invalid licenseNumber" withTitle:@"Validation"];
  //    validateOk = NO;
  //  }
  return validateOk;
}

- (void)signUpforDoctorWithParams:(NSDictionary *)params success:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:params path:usersPath];
  [operation perform:^(NSDictionary *json) {
    self.userId = [json valueForKeyPath:@"user.id"];
    [self updateAttributeWithJson:json];
    currentUser = self;
    [[RingData sharedInstance] saveContext];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (NSDictionary *)toUserParamaters
{
  return @{@"agree_on_terms": @(YES), @"email": self.email, @"password": self.password, @"password_confirmation" : self.password, @"full_name": self.name, @"role": [self.isDoctor boolValue] ? @"doctor" : @"patient", @"phone_code" : self.phoneCode, @"phone_raw_number": self.phoneRawNumber};
}

- (void)signUpforPatientWithSuccess:(void(^)(void))successBlock
{
  [self signUpforDoctorWithParams:@{@"user" : [self toUserParamaters]} success:successBlock];
}

- (void)signUpforDoctorWithCountryId:(NSNumber *)countryId andSpecialityId:(NSNumber *)specialityId licenseNumber:(NSString *)licenseNumber success:(void(^)(void))successBlock
{
  [self signUpforDoctorWithParams:@{@"user" : [self toUserParamaters], @"doctor_profile" : @{ @"country_id": countryId, @"license_number": licenseNumber, @"speciality_ids" : @[specialityId], @"price_per_hour": self.pricePerHour, @"currency" : self.currency.lowercaseString}} success:successBlock];
}

- (void)loadNotifications
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:notificationsPath];
  [operation perform:^(NSDictionary *json) {
    ringDelegate.unreadConversationIds = [[json objectForKey:@"unread_conversation_ids"] mutableCopy];
    ringDelegate.unreadRequestIds = [[json objectForKey:@"unread_request_ids"] mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
  } modally:NO];
}

- (void)relyMessage:(NSString *)message toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock
{
  [RingMessage createMessageWithContent:message toUser:user withSuccess:successBlock];
}

- (void)relyImage:(UIImage *)image toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock
{
  [RingMessage createMessageWithImage:image toUser:user withSuccess:successBlock];
}

+ (void)forgotPasswordWithEmail:(NSString *)email success:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"email" : email} fullPath:userPasswordPath];
  [operation perform:^(id json) {
    if (successBlock) {
      successBlock();
    }
  } modally:YES];
}

+ (void)changePasswordWithCurrentPassword:(NSString *)currentPass newPassWord:(NSString *)password success:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"user" : @{@"password" : password, @"password_confirmation" : password, @"current_password" : currentPass}} path:changePasswordPath];
  [operation perform:^(id json) {
    if (successBlock) {
      successBlock();
    }
  } modally:YES];
}

- (void)subscribe
{
  if(pusherApiKey == nil) {
    return;
  }
  
  [[RingPusher sharedInstance] connect];
  if (![self isSubscribed]) {
    NSLog(@"Will subscribe to Pusher notifications");
    [[RingPusher sharedInstance] subscribeToChannel:[self channelName] withEvents:[userEvents componentsSeparatedByString:@", "]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageEvent:) name:PE_messageAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserEvent:) name:PE_userNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCallRequest:) name:PE_cancelRequest object:nil];
    [self loadNotifications];
  } else {
    NSLog(@"Already subscribed to Pusher notifications");
  }
}

- (NSString *)fullChannelName
{
  return [NSString stringWithFormat:@"private-%@", self.userId];
}

- (NSString *)channelName
{
  return [NSString stringWithFormat:@"%@", self.userId];
}

- (BOOL)isSubscribed
{
  return [[RingPusher sharedInstance] isContainChannel:[self channelName]];
}

- (void)unSubscribe
{
  [[RingPusher sharedInstance] unsubscribeFromChannel:[self channelName]];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeCallRequest:(NSNotification *)notification
{
  RingCallRequest *callRequest = [RingCallRequest findById:[notification.userInfo objectForKey:@"request_id"]];
  if (callRequest) {
    [[RingUser currentCacheUser] removeCallRequestsObject:callRequest];
    [[NSNotificationCenter defaultCenter] postNotificationName:ME_requestRemoved object:callRequest];
  }
}

- (void)newUserEvent:(NSNotification *)notification
{
  RingNotification *ringNotification = [RingNotification insertWithJSON:notification.userInfo];
  if ([ringNotification.notificationType isEqualToString:CALL_REQUEST_TYPE] || [ringNotification.notificationType isEqualToString:VIDEO_REQUEST_TYPE]) {
    id object_id = [notification.userInfo objectForKey:@"request_id"];
    if (!object_id) {
      object_id = [notification.userInfo objectForKey:@"object_id"];
    }
    if (!object_id) {
      object_id = [notification.userInfo objectForKey:@"action_object_id"];
    }
    RingCallRequest *callRequest = [RingCallRequest insertOrUpdateWithJSON:@{@"id": object_id}];
    [ringDelegate.unreadRequestIds addNumber:callRequest.callRequestId];
    [callRequest pullCallRequestDetailWithSuccess:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:ME_requestUpdated object:callRequest];
    } modally:NO];
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
}

- (void)newMessageEvent:(NSNotification *)notification
{
  NSLog(@"New message via Pusher");
  
  NSNumber *senderId = notification.userInfo[@"sender_id"];
  
  if(! [senderId isEqualToNumber:currentUser.userId]) {
    [ringDelegate.unreadConversationIds addNumber:senderId];
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_messageUpdated object:nil];
}
@end
