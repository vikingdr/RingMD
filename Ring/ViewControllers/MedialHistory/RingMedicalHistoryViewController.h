//
//  RingMedicalHistoryViewController.h
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingUser;

@interface RingMedicalHistoryViewController : UIViewController
@property (weak, nonatomic) RingUser *user;
@property (nonatomic) BOOL editable;
@end
