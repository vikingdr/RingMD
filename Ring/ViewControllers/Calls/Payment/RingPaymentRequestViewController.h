//
//  RingPaymentRequestViewController.h
//  Ring
//
//  Created by Medpats on 5/12/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingUser, RingCallRequest;

@interface RingPaymentRequestViewController : UIViewController
@property (weak, nonatomic) RingUser *doctor;
@property (nonatomic, weak) RingCallRequest *callRequest;
@end
