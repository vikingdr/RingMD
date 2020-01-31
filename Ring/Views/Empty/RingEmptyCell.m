//
//  RingEmptyCell.m
//  Ring
//
//  Created by Medpats on 7/10/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingEmptyCell.h"

#import "Ring-Essentials.h"

@implementation RingEmptyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self decorateUIs];
}

- (void)decorateUIs
{
  self.titleEmpty.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.titleEmpty.textColor = [UIColor ringMainColor];
  self.subTitleEmpty.textColor = [UIColor blackColor];
  self.subTitleEmpty.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}
@end
