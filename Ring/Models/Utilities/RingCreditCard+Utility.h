//
//  RingCreditCard+Utility.h
//  Ring
//
//  Created by Medpats on 12/6/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingCreditCard.h"

@class RingCallRequest;

@interface RingCreditCard (Utility)
- (NSString *)shortInfo;
- (NSString *)expireAt;
- (BOOL)validateFields;
- (NSString *)method;

+ (RingCreditCard *)createEmpty;
+ (void)loadAllWithSuccess:(void(^)(NSArray * cards))successBlock;
- (void)addCardWithSuccess:(void(^)(void))successBlock;
+ (void)deleteCard:(RingCreditCard *)card andSuccess:(void(^)(void))successBlock;
- (void)generateTokenCardForRequest:(RingCallRequest *)callRequest WithSuccess:(void(^)(NSString *token))successBlock;
@end
