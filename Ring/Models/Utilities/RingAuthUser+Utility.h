//
//  RingAuthUser+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/9/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingAuthUser.h"

@class RingUser;

@interface RingAuthUser (Utility)
+ (RingAuthUser *)createEmptyUser;
+ (RingAuthUser *)insertWithJSON:(NSDictionary *)jsonData;
+ (RingAuthUser *)firstUser;
+ (RingAuthUser *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;

- (BOOL)isSubscribed;
- (BOOL)validateFields;
- (BOOL)validateDoctorFields;
- (void)updateAttributeWithJson:(NSDictionary *)jsonData;
- (NSURL *)avatarUrl;
- (UIImage *)avatarImage;

//pusher
- (NSString *)channelName;
- (NSString *)fullChannelName;

//SERVER REQUESTS
+ (void)loginWithEmail:(NSString *)email password:(NSString *)password andSuccess:(void(^)(void))successBlock;
- (void)signUpforPatientWithSuccess:(void(^)(void))successBlock;
- (void)signUpforDoctorWithCountryId:(NSNumber *)countryId andSpecialityId:(NSNumber *)specialityId licenseNumber:(NSString *)licenseNumber success:(void(^)(void))successBlock;
- (void)loadNotifications;

//messages
- (void)relyImage:(UIImage *)image toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock;
- (void)relyMessage:(NSString *)message toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock;

//user
+ (void)forgotPasswordWithEmail:(NSString *)email success:(void(^)(void))successBlock;
+ (void)changePasswordWithCurrentPassword:(NSString *)currentPass newPassWord:(NSString *)password success:(void(^)(void))successBlock;

//pusher
- (void)subscribe;
- (void)unSubscribe;
@end
