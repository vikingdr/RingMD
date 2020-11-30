//
//  RingDoctorInfoView.h
//  Ring
//
//  Created by Medpats on 12/18/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

@class RingUser;

@interface RingDoctorInfoView : UIView
@property (strong, nonatomic) RingUser *doctor;
+ (id)doctorInfoViewWithDoctor:(RingUser *)doctor;

- (void)checkUserStatus;
- (void)decorateUIs;
@end
