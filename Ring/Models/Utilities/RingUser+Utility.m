//
//  RingUser+Utility.m
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "RingUser+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingPusher.h"
#import "NSArray+Compare.h"

@implementation RingUser (Utility)
+ (RingUser *)insertWithJSON:(NSDictionary *)jsonData
{
  RingUser *user = [NSEntityDescription
                      insertNewObjectForEntityForName:@"RingUser"
                      inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [user updateAttributeWithJson:jsonData];
  return user;
}

+ (RingUser *)currentCacheUser
{
  if(currentUser)
    return [self findById:currentUser.userId];
  return nil;
}

+ (NSArray *)featuredDoctors
{
  NSMutableArray *doctors = [[[RingData sharedInstance] findEntities:@"RingUser" withPredicateString:@"role == %@ AND featuredRank > 0" andArguments:@[@"doctor"] withSortDescriptionKeys:@{@"featuredRank": @YES}] mutableCopy];
  [doctors  removeObject:[self currentCacheUser]];
  return [doctors copy];
}

+ (void)searchDoctorsWithText:(NSString *)keyword pageNumber:(NSInteger)pageNumber proceed:(void(^)(NSArray *))successBlock blockView:(UIView *)blockView
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"search_by": @"name", @"keyword": keyword, @"page": @(pageNumber), @"per_page": @(perPage)} path:doctorsPath];
  [operation perform:^(NSArray *json) {
    NSMutableArray *doctors = [NSMutableArray arrayWithCapacity:json.count];
    for(NSDictionary *doctorInfo in json) {
      [doctors addObject:[RingUser insertOrUpdateWithJSON:doctorInfo]];
    }
    successBlock(doctors);
  } blockView:blockView json:YES numberOfPreviousAttempts:0];
}

+ (void)insertRingAuthUser:(RingAuthUser *)user
{
  assert(user != nil);
  if (!user.avatar) {
    user.avatar = @"";
  }
  [self insertOrUpdateWithJSON:@{@"full_name" : user.name, @"id" : user.userId, @"avatar" : user.avatar, @"phone_code": (user.phoneCode ? user.phoneCode : @""), @"phone_raw_number": (user.phoneRawNumber ? user.phoneRawNumber : @""), @"role": ([user.isDoctor boolValue] ? @"doctor" : @"patient")}];
}

+ (RingUser *)findByName:(NSString *)name
{
  return (RingUser *)[[RingData sharedInstance] findSingleEntity:@"RingUser" withPredicateString:@"name == %@" andArguments:@[name] withSortDescriptionKey:nil];
}

+ (RingUser *)findById:(NSNumber *)userId
{
  return (RingUser *)[[RingData sharedInstance] findSingleEntity:@"RingUser" withPredicateString:@"userId == %@" andArguments:@[userId] withSortDescriptionKey:nil];
}

+ (RingUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key
{
  RingUser *user = [self findById:[jsonData objectForKey:key]];
  NSNumber *userId = @([[jsonData objectForKey:key] integerValue]);
  NSMutableDictionary *removedIdJson = [jsonData mutableCopy];
  [removedIdJson removeObjectForKey:key];
  if (user)
    [user updateAttributeWithJson:removedIdJson];
  else {
    user = [RingUser insertWithJSON:removedIdJson];
    user.userId = userId;
  }
  
  return user;
}

+ (RingUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  return [self insertOrUpdateWithJSON:jsonData withIdKey:@"id"];
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *userJson in jsonArray) {
      [results addObject:[RingUser insertOrUpdateWithJSON:userJson]];
    }
  }
  return results;
}

//- (BOOL)isBusyOnDate:(NSDate *)date
//{
//  NSArray *busyTimes = [[self.busyHours filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"from >= %@ AND from <= %@ OR to >= %@ AND to <= %@", [date beginOfDay], [date endOfDay], [date beginOfDay], [date endOfDay]]] allObjects];
//  
//  return [busyTimes count] > 0;
//}

- (RingPatientAnswer *)createAnswer:(BOOL)yesNo forQuestion:(RingPatientQuestion *)question
{
  NSLog(@"createAnswer %@ for %@", @(yesNo), question.patientQuestionId);
  RingPatientAnswer *patientAnswer = [RingPatientAnswer createEmpty];
  patientAnswer.patientQuestionId = question.patientQuestionId;
  patientAnswer.user = self;
  patientAnswer.value = @(yesNo);
  return patientAnswer;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"name" : @"full_name", @"authToken": @"token", @"location" : @"location", @"role" : @"role",
                            @"about" : @"introduction", @"numReviews" : @"num_of_reivews",
                            @"numSpecialities" : @"num_of_specialities",
                            @"rating": @"average_rating", @"profileId" : @"id", @"canReview" :  @"can_review", @"numVideos": @"number_of_videos", @"numCalls": @"number_of_calls", @"phoneCode": @"phone_code", @"phoneRawNumber": @"phone_raw_number", @"pricePerMinuteText" : @"price_per_minute_text", @"currentTreatment" : @"medical_treatments", @"currentSymptoms" : @"symptoms", @"phoneCode": @"phone_code", @"phoneRawNumber" : @"phone_raw_number"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
  if ([jsonData objectForKey:@"specialities"]) {
    self.specialities = [[NSSet alloc] initWithArray:[RingSpeciality insertOrUpdateWithJSONArray:[jsonData objectForKey:@"specialities"]]];
  }
  NSString *avatar = [jsonData objectForKey:@"avatar"];
  NSString *avatarFull = [jsonData objectForKey:@"avatar_256"];
  if (avatar) {
    self.avatar = [RingUtility fullUrlString:avatar];
  }
  if (avatarFull) {
    self.avatarFull = [RingUtility fullUrlString:avatarFull];
  }
  if ([jsonData objectForKey:@"doctor"] && ![[jsonData objectForKey:@"doctor"] isEqual:[NSNull null]]) {
    [self updateAttributeWithJson:[jsonData objectForKey:@"doctor"]];
  }
  if ([jsonData objectForKey:@"user"] && ![[jsonData objectForKey:@"user"] isEqual:[NSNull null]]) {
    [self updateAttributeWithJson:[jsonData objectForKey:@"user"]];
  }
  if ([jsonData objectForKey:@"anwsers"] && ![[jsonData objectForKey:@"anwsers"] isEqual:[NSNull null]]) {
    self.patientAnswers = [[NSSet alloc] initWithArray:[RingPatientAnswer insertOrUpdateWithJSONArray:[jsonData objectForKey:@"anwsers"]]];
  }
}

- (NSArray *)latestMessages
{
  NSMutableArray *messages = [NSMutableArray array];
  [messages addObjectsFromArray:[self.sentMessages allObjects]];
  [messages addObjectsFromArray:[self.receiveMessages allObjects]];
  NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
  return [messages sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSArray *)latestCallCallRequests
{
  NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"callRequestId" ascending:NO];
  return [self.callRequests sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSArray *)activeRequests // for current user
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@ OR state = %@" argumentArray:@[@"paid", @"accepted"]];
  if (IS_DOCTOR) {
    return [[self.receiveRequests filteredSetUsingPredicate:predicate] allObjects];
  } else {
    return [[self.callRequests filteredSetUsingPredicate:predicate] allObjects];
  }
}

- (NSArray *)historyRequests // for current user
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@ OR state = %@ OR state = %@ OR state = %@ OR state = %@" argumentArray:@[@"finished", @"expired", @"missed", @"canceled", @"payment_captured"]];
  if (IS_DOCTOR) {
    return [[self.receiveRequests filteredSetUsingPredicate:predicate] allObjects];
  } else {
    return [[self.callRequests filteredSetUsingPredicate:predicate] allObjects];
  }
}

- (RingCallRequest *)callNowRequest // for current user
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@ AND (callTime <= %@ AND callTime >= %@)" argumentArray:@[@"accepted", [[NSDate date] dateInNexMinutes:[RingUtility timeBeforeDisplayCallButton]], [[NSDate date] dateInNexMinutes:-[RingUtility timeAfterDisplayCallButton]]]];
  
  if (IS_DOCTOR) {
    return [[[self.receiveRequests filteredSetUsingPredicate:predicate] allObjects] firstObject];
  } else {
    return [[[self.callRequests filteredSetUsingPredicate:predicate] allObjects] firstObject];
  }
}

- (NSString *)firstSpeciality
{
  return [[[self.specialities allObjects] firstObject] name];
}

- (UIImage *)avatarImage
{
  return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]]];
}

- (NSArray *)specialityIds
{
  NSMutableArray *ids = [[NSMutableArray alloc] init];
  NSArray *objects = [self.specialities allObjects];
  for (NSInteger i = 0; i < [objects count]; ++i) {
    [ids addObject:[[objects objectAtIndex:i] specialityId]];
  }
  return ids;
}

- (NSURL *)bestQualityAvatarUrl
{
  if (self.avatarFull)
    return [NSURL URLWithString:self.avatarFull];
  if (self.avatar)
    return [NSURL URLWithString:self.avatar];
  return [NSURL URLWithString:@"http://ring.md/assets/no_image_first_time.png"];
}

- (BOOL)isDoctor
{
  return [self.role isEqualToString:@"doctor"];
}

- (NSString *)profilePath {
  return [NSString stringWithFormat:self.isDoctor ? doctorProfilePath : patientProfilePath , self.userId];
}

- (void)getFullUserInfoWithSuccess:(void(^)(void))successBlock modally:(BOOL)modally
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:[self profilePath]];
  [operation perform:^(NSDictionary *json) {
    [self updateAttributeWithJson:json];
    if(successBlock)
      successBlock();
  } modally:modally];
}

- (void)loadMessageWithPage:(NSInteger)page andSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"receiver_id" : self.userId, @"page" : @(page), @"per_page": @(perPage)} path:messageToPath];
  [operation perform:^(NSDictionary *json) {
    [RingMessage insertOrUpdateWithJSONArray:[json objectForKey:@"messages"]];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (NSString *)upload_url
{
  return [NSString stringWithFormat:@"public/user/avatar/%@/%@", self.userId, @"avatar.png"];
}

- (void)uploadAvatar:(UIImage *)image
{
  UIImage *resizedImage = [image resizeToUploadAvatar];
  [FileUploader uploadAvatar:resizedImage proceed:^(NSString *url){
    [self updateProfile:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:ME_userAvatarUpdated object:nil];
    } withAvatarURL:url];
  }];
}

//- (void)notifyUploaded
//{
//  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"user" : @{@"avatar" : @"avatar.png"}} path:changeAvatarPath];
//  [operation perform:^(id json) {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ME_userAvatarUpdated object:nil];
//  } modally:YES];
//}

- (BOOL)isOnline
{
  return [[ringDelegate onlineUserIds] containsNumber:self.userId];
}

- (BOOL)isFavorited:(RingUser *)user
{
  return [self.favorites containsObject:user];
}

- (NSDictionary *)toParammeters
{
  if (!self.about) {
    self.about = @"";
  }
  
  NSMutableDictionary *userParams = [NSMutableDictionary new];
  if(self.name != nil) {
    userParams[@"full_name"] = self.name;
  }
  if(self.location != nil) {
    userParams[@"location"] = self.location;
  }
  if(self.phoneCode != nil) {
    userParams[@"phone_code"] = self.phoneCode;
  }
  if(self.phoneRawNumber != nil) {
    userParams[@"phone_raw_number"] = self.phoneRawNumber;
  }
  
  if (IS_DOCTOR) {
    //TODO: add price_per_minute
    return @{@"doctor" : @{@"introduction": self.about}, @"user" : userParams, @"specialities" : [self specialityIds]};
  }
  return @{@"user" : userParams};
}

- (NSDictionary *)toPatientAnswers
{
  NSMutableArray *answers = [NSMutableArray array];
  for (RingPatientAnswer *answer in self.patientAnswers) {
    [answers addObject:@{@"patient_question_id" : answer.patientQuestionId, @"answer" : @{@"value" : @(answer.valueValue), @"extra_answer" : answer.answer  == nil ? @"" : answer.answer}}];
  }
  if (self.currentSymptoms == nil) {
    self.currentSymptoms = @"";
  }
  if (self.currentTreatment == nil) {
    self.currentTreatment = @"";
  }
  return @{@"answers" : answers, @"medical_treatments" : self.currentTreatment, @"symptoms" : self.currentSymptoms};
}

- (void)updateProfile:(void(^)(void))successBlock withAvatarURL:(NSString *)avatarURL
{
  NSMutableDictionary *params = [[self toParammeters] mutableCopy];
  if(avatarURL) {
    NSMutableDictionary *userDict = [params[@"user"] mutableCopy];
    userDict[@"remote_avatar_tmp_url"] = avatarURL;
    params[@"user"] = userDict;
  }
  
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"PUT" params:params path:[self profilePath]];
  [operation perform:^(NSDictionary *json) {
    [self updateAttributeWithJson:json];
    
    currentUser.name = self.name;
    currentUser.about = self.about;
    currentUser.phoneCode = self.phoneCode;
    currentUser.phoneRawNumber = self.phoneRawNumber;
    currentUser.avatar = self.avatar;
    [[RingData sharedInstance] saveContext];
    if(successBlock)
      successBlock();
  } modally:YES];
}

- (void)updatePatientHistory:(void(^)(void))successBlock
{
  //FIXME: This currently seems to reset existing data
  NSLog(@"Will update medical history: %@", [self toPatientAnswers]);
  
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:[self toPatientAnswers] path:patientProfileAnswerPath];
  [operation perform:^(id json) {
    [[RingData sharedInstance] saveContext];
    if(successBlock)
      successBlock();
  } modally:YES];
}

+ (void)loadDoctorWithPage:(NSInteger)page priority:(NSOperationQueuePriority)priority andSuccess:(void(^)(NSArray* results))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"page" : @(page), @"per_page" : @(perPage)} path:expertDoctorsPath];
  [operation perform:^(NSArray *json) {
    NSArray *result = [RingUser insertOrUpdateWithJSONArray:json];
    if (successBlock)
      successBlock(result);
  } modally:YES];
}

- (void)loadFavoriteDoctorsWithPage:(NSInteger)page andSuccess:(void(^)(void))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"page" : @(page), @"per_page" : @(perPage)} path:favoritesPath];
  [operation perform:^(NSArray *json) {
    NSArray *users = [RingUser insertOrUpdateWithJSONArray:json];
    NSMutableOrderedSet *favorites = [self.favorites mutableCopy];
    [favorites addObjectsFromArray:users];
    self.favorites = [favorites copy];
//    NSLog(@"new number of favorites: %d", self.favorites.count);
    if (successBlock)
      successBlock();
   } modally:page == 1];
}

+ (void)featuredDoctorsWithSuccess:(void(^)(NSArray *))successBlock page:(NSInteger)pageNumber
{  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"page" : @(pageNumber), @"per_page" : @(perPage)} fullPath:[apiVersionPath stringByAppendingString:expertDoctorsPath]];
  [operation perform:^(NSArray *json) {
    NSArray *results = [RingUser insertOrUpdateWithJSONArray:json];
    
    NSInteger featuredRank = (pageNumber - 1) * perPage;
    for(RingUser *doctor in results) {
      doctor.featuredRank = @(++featuredRank);
    }
    
    if (successBlock)
      successBlock(results);
  } modally:pageNumber == 1];
}

- (void)loadSlotInDate:(NSDate *)date withDuration:(NSNumber *)duration selectedDates:(NSArray *)selectedDates andSuccess:(void(^)(NSArray *results))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"date" : [date dateSubmitServerFormat], @"expected_duration_in_minutes" : duration, @"selected_slots": selectedDates, @"time_zone": [NSDate localTimezoneName]} path:[NSString stringWithFormat:availableTimeProfilePath, self.userId]];
  [operation perform:^(NSArray *json) {
    NSArray *result = [RingBusyHour insertWithJSONArray:json];
    if (successBlock)
      successBlock(result);
  } modally:YES];
}

- (void)removeUser:(RingUser*)user fromFavoritesSuccess:(void(^)(void))success
{
  typeof(success)successBlock = [success copy];
  
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"favorite_user_id" : user.userId} path:removeFavoritePath];
  [operation perform:^(id json) {
    NSMutableOrderedSet *favorites = [self.favorites mutableCopy];
    [favorites removeObject:user];
    self.favorites = [favorites copy];
    if (successBlock)
      successBlock();
  } modally:YES];
}

- (void)addUser:(RingUser*)user toFavoritesSuccess:(void(^)(void))success
{
  typeof(success)successBlock = [success copy];
  
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"POST" params:@{@"favorite_user_id" : user.userId} path:favoritesPath];
  [operation perform:^(id json) {
    NSMutableOrderedSet *favorites = [self.favorites mutableCopy];
    [favorites addObject:user];
    self.favorites = [favorites copy];
    if (successBlock)
      successBlock();
  } modally:YES];
}

- (void)loadUnavailableDates:(NSDate *)date andSuccess:(void(^)(NSArray *dates))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"date" : [date dateSubmitServerFormat], @"time_zone": [NSDate localTimezoneName]} path:[NSString stringWithFormat:profileUnavailablesDatesPath, self.userId]];
  [operation perform:^(NSArray *json) {
    if (successBlock) {
      successBlock(json);
    }
  } modally:YES];
}

- (void)loadSugestedSlotsWithSuccess:(void(^)(NSArray *dates))successBlock
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{@"time_zone": [NSDate localTimezoneName]} path:[NSString stringWithFormat:profileSugestedSlotsPath, self.userId]];
  [operation perform:^(NSArray *json) {
    NSArray *result = [RingTimeSlot insertWithJSONArray:json];
    if (successBlock) {
      successBlock(result);
    }
  } modally:YES];
}

- (NSString *)phoneNumber
{
  return [NSString stringWithFormat:@"%@%@",
          self.phoneCode ? self.phoneCode : @"",
          self.phoneRawNumber ? self.phoneRawNumber : @""];
}
@end
