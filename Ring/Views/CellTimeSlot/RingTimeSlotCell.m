//
//  RingTimeSlotCell.m
//  Ring
//
//  Created by Medpats on 5/14/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingTimeSlotCell.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@implementation RingTimeSlotCell

- (void)setTimeSlot:(RingTimeSlot *)timeSlot
{
  _timeSlot = timeSlot;
  [self updateValues];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self decorateUIs];
    }
    return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self decorateUIs];
}

- (void)updateValues
{
  self.dateText.text = [self.timeSlot.callTime defaultFormat];
}

- (void)decorateUIs
{
  self.dateText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.dateText.textColor = [UIColor blackColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
  self.selectedIcon.highlighted = selected;
  if (selected) {
    self.backgroundColor = [UIColor ringWhiteColor];
  } else {
    self.backgroundColor = [UIColor whiteColor];
  }
}

- (void)hideSelectIcon
{
  self.selectedIcon.hidden = YES;
}

@end
