//
//  RingBusinessTimeCell.m
//  Ring
//
//  Created by Medpats on 7/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingBusinessTimeCell.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@interface RingBusinessTimeCell()
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *toText;
@property (weak, nonatomic) IBOutlet UILabel *fromText;

@end

@implementation RingBusinessTimeCell
- (void)awakeFromNib
{
  [self decorateUIs];
}

- (void)setBusinessHour:(RingBusinessHour *)businessHour
{
  _businessHour = businessHour;
  [self updateValues];
}

- (void)decorateUIs
{
  self.fromText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.toText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}

- (void)updateValues
{
  self.fromText.text = [self.businessHour.from hourFormat];
  self.toText.text = [self.businessHour.to hourFormat];
}
@end
