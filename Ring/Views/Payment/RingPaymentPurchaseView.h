//
//  RingPaymentPurchaseView.h
//  Ring
//
//  Created by Medpats on 12/16/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingCreditCard;

@interface RingPaymentPurchaseView : UIWebView
+ (RingPaymentPurchaseView *)initWithToken:(NSString *)token creditCardMemberId:(NSString *)cardId requestId:(NSNumber *)requestId andFrame:(CGRect)frame;
+ (RingPaymentPurchaseView *)initWithCard:(RingCreditCard *)card requestId:(NSNumber *)requestId andFrame:(CGRect)frame;

- (void)loadDataFromCard:(RingCreditCard *)card requestId:(NSNumber *)requestId;
@end
