//
//  RingProfileCell.m
//  Ring
//
//  Created by Tan Nguyen on 11/15/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingProfileCell.h"

#import "Ring-Essentials.h"

@interface RingProfileCell()

@end

@implementation RingProfileCell

- (void)decorateUIs
{
  self.profileCellText.textColor = [UIColor ringLightMainColor];
  self.profileCellText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
}

@end
