//
//  RingPickRequestDateViewController.h
//  Ring
//
//  Created by Medpats on 5/14/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingUser;

@protocol RingPickRequestDateDelegate
- (void)pickRequestDateViewController:(id)RingPickRequestDateViewController dateChanged:(NSDate *)date;
@end

@interface RingPickRequestDateViewController : UIViewController
@property (strong,nonatomic) NSDate *initialDate;
@property (weak, nonatomic) RingUser *doctor;
@property (strong, nonatomic) NSArray *selectedSlots;
@property (nonatomic, weak) id<RingPickRequestDateDelegate> dateDelegate;
@end
