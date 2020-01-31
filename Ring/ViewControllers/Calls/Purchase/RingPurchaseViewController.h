//
//  RingPurchaseViewController.h
//  Ring
//
//  Created by Medpats on 5/13/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingCallRequest, RingCreditCard;

@interface RingPurchaseViewController : UIViewController
@property (strong, nonatomic) RingCallRequest *request;
@property (strong, nonatomic) RingCreditCard *card;
@end
