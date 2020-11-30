//
//  RingTimeSlotCell.h
//  Ring
//
//  Created by Medpats on 5/14/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingTimeSlot;

@interface RingTimeSlotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;

@property (weak, nonatomic) RingTimeSlot *timeSlot;

- (void)hideSelectIcon;
@end
