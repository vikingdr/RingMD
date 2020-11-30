//
//  RingBusyTimeCell.m
//  Ring
//
//  Created by Medpats on 7/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusyTimeCell.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@interface RingBusyTimeCell()
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *toText;
@property (weak, nonatomic) IBOutlet UILabel *fromText;

@end

@implementation RingBusyTimeCell
- (void)awakeFromNib
{
  [self decorateUIs];
}

- (void)setBusyHour:(RingBusyHour *)busyHour
{
  _busyHour = busyHour;
  [self updateValues];
}

- (void)decorateUIs
{
  self.fromText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.toText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}

- (void)updateValues
{
  self.fromText.text = [self.busyHour.from shortDisplayFormat];
  self.toText.text = [self.busyHour.to shortDisplayFormat];
}
@end
