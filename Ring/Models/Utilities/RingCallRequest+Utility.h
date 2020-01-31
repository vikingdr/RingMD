//
//  RingCallRequest+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/10/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingCallRequest.h"

#define VOICE_CALL @"CallRequest"
#define VIDEO_CALL @"VideoRequest"

@interface RingCallRequest (Utility)
+ (RingCallRequest *)createWithUser:(RingUser *)user;
+ (RingCallRequest *)findById:(NSNumber *)callRequestId;
+ (RingCallRequest *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
- (RingUser *)user;
- (NSDate *)acceptedDate;
- (BOOL)isRequested;
- (BOOL)isFinished;
- (BOOL)isInProgress;
- (BOOL)isAccepted;
- (BOOL)canRate;
- (void)setGoingFinish;
- (BOOL)isGoingFinish;
- (BOOL)isNormalCall;
- (BOOL)validate;
- (BOOL)canCallNow;
//Submit server
+ (void)loadHistoryCallRequestsWithPage:(NSInteger )page andSuccess:(void(^)(NSArray *callRequests))successBlock blockView:(UIView *)blockView;
+ (void)loadActiveCallRequestsWithPage:(NSInteger )page andSuccess:(void(^)(NSArray *callRequests))successBlock blockView:(UIView *)blockView;
- (void)pullCallRequestDetailWithSuccess:(void(^)(void))successBlock modally:(BOOL)modally;
- (void)pullOpenTokChatRoom:(void(^)(void))successBlock;
- (void)submitRequest:(void(^)(void))successBlock;
- (void)requestFinishedSessionWithSuccess:(void(^)(void))successBlock andFailed:(void(^)(void))failBlock;
//- (void)requestStartSessionWithSuccess:(void(^)(void))successBlock;
- (void)cancelRequestWithSuccess:(void(^)(void))successBlock;
- (void)rate:(CGFloat)rate withContent:(NSString *)content andSuccess:(void(^)())successBlock;
@end
