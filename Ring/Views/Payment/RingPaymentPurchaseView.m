//
//  RingPaymentPurchaseView.m
//  Ring
//
//  Created by Medpats on 12/16/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPaymentPurchaseView.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#define purchaseTokenPath @"/requests/%@/checkout?memberPay_service=T&memberPay_token=%@&memberPay_memberId=%@&user_token=%@"
#define purchaseNewCardPath @"/requests/%@/checkout?pMethod=%@&epMonth=%@&epYear=%@&cardNo=%@&securityCode=%@&cardHolder=%@&user_token=%@"

@interface RingPaymentPurchaseView()
@property (strong, nonatomic) NSString *paymentUrl;
@end

@implementation RingPaymentPurchaseView

+ (RingPaymentPurchaseView *)initWithToken:(NSString *)token creditCardMemberId:(NSString *)cardId requestId:(NSNumber *)requestId andFrame:(CGRect)frame
{
  NSLog(@"Init purchase view WITH token");
  RingPaymentPurchaseView *paymentView = [[RingPaymentPurchaseView alloc] initWithFrame:frame];
  paymentView.delegate = [PauzeOverlayWebViewDelegate sharedInstance];
  paymentView.paymentUrl = [NSString stringWithFormat:purchaseTokenPath, requestId, token, cardId, currentUser.authToken];
  NSString *urlString = [NSString stringWithFormat:@"%@%@%@", serverAddress, apiVersionPath,paymentView.paymentUrl];
  NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [paymentView loadRequest:request];
  return paymentView;
}

+ (RingPaymentPurchaseView *)initWithCard:(RingCreditCard *)card requestId:(NSNumber *)requestId andFrame:(CGRect)frame
{
  NSLog(@"Init purchase view WITHOUT token");
  RingPaymentPurchaseView *paymentView = [[RingPaymentPurchaseView alloc] initWithFrame:frame];
  [paymentView loadDataFromCard:card requestId:requestId];
  return paymentView;
}

- (void)loadDataFromCard:(RingCreditCard *)card requestId:(NSNumber *)requestId
{
  self.delegate = [PauzeOverlayWebViewDelegate sharedInstance];
  self.paymentUrl = [NSString stringWithFormat:purchaseNewCardPath, requestId, [card method] , card.expireMonth, card.expireYear, card.number, card.code, card.holder, currentUser.authToken];
  NSString *urlString = [NSString stringWithFormat:@"%@%@%@", serverAddress, apiVersionPath,self.paymentUrl];
  NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [self loadRequest:request];
}
@end
