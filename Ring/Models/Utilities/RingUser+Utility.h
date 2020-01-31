//
//  RingUser+Utility.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "RingUser.h"

@class RingAuthUser, RingPatientQuestion, RingPatientAnswer;

@interface RingUser (Utility)
+ (NSArray *)featuredDoctors;
+ (void)searchDoctorsWithText:(NSString *)keyword pageNumber:(NSInteger)pageNumber proceed:(void(^)(NSArray *))successBlock blockView:(UIView *)blockView;
+ (RingUser *)insertWithJSON:(NSDictionary *)jsonData;
+ (void)insertRingAuthUser:(RingAuthUser *)user;
+ (RingUser *)currentCacheUser;
+ (RingUser *)findById:(NSNumber *)userId;
+ (RingUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
+ (RingUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;

//- (BOOL)isBusyOnDate:(NSDate *)date;
- (RingPatientAnswer *)createAnswer:(BOOL)yesNo forQuestion:(RingPatientQuestion *)question;
- (void)updateAttributeWithJson:(NSDictionary *)jsonData;
- (NSURL *)bestQualityAvatarUrl;
- (NSArray *)latestCallCallRequests;
- (NSArray *)activeRequests;
- (NSArray *)historyRequests;
- (NSArray *)latestMessages;
- (UIImage *)avatarImage;
- (NSString *)firstSpeciality;
- (BOOL)isFavorited:(RingUser *)user;
- (BOOL)isOnline;

- (RingCallRequest *)callNowRequest;

- (void)getFullUserInfoWithSuccess:(void(^)(void))successBlock modally:(BOOL)modally;
- (void)loadMessageWithPage:(NSInteger)page andSuccess:(void(^)(void))successBlock;
- (void)updateProfile:(void(^)(void))successBlock withAvatarURL:(NSString *)avatarURL;
- (void)updatePatientHistory:(void(^)(void))successBlock;
- (void)uploadAvatar:(UIImage *)image;

- (void)loadFavoriteDoctorsWithPage:(NSInteger)page andSuccess:(void(^)(void))successBlock;
- (void)addUser:(RingUser*)user toFavoritesSuccess:(void(^)(void))successBlock;
- (void)removeUser:(RingUser*)user fromFavoritesSuccess:(void(^)(void))successBlock;

- (void)loadSlotInDate:(NSDate *)date withDuration:(NSNumber *)duration selectedDates:(NSArray *)selectedDates andSuccess:(void(^)(NSArray *results))successBlock;
- (void)loadUnavailableDates:(NSDate *)date andSuccess:(void(^)(NSArray *dates))successBlock;
- (void)loadSugestedSlotsWithSuccess:(void(^)(NSArray *dates))successBlock;

+ (void)featuredDoctorsWithSuccess:(void(^)(NSArray* results))successBlock page:(NSInteger)pageNumber;

- (NSString *)phoneNumber;
@end
