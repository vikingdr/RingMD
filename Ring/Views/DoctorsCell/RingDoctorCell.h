//
//  RingDoctorCell.h
//  Ring
//
//  Created by Medpats on 1/14/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "MGSwipeTableCell.h"

@class RingUser;

@protocol RingDoctorCellDelegate <MGSwipeTableCellDelegate>
- (void)doctorCellRefreshUser:(RingUser *)user;
@end

@interface RingDoctorCell : MGSwipeTableCell
@property (weak, nonatomic) id<RingDoctorCellDelegate> delegate;
@property (nonatomic) RingUser *user;

+ (NSString *)nibName;
@end
