//
//  RingSpecialityCell.m
//  Ring
//
//  Created by Medpats on 5/8/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingSpecialityCell.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@interface RingSpecialityCell()
@property (weak, nonatomic) IBOutlet UILabel *specialityName;

@end

@implementation RingSpecialityCell

-  (void)setSpeciality:(RingSpeciality *)speciality
{
  _speciality = speciality;
  [self updateValues];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self updateUIs];
    }
    return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self updateUIs];
}

- (void)updateUIs
{
  self.specialityName.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.specialityName.textColor = [UIColor ringDarkGrayColor];
}

- (void)updateValues
{
  self.specialityName.text = self.speciality.name;
}
@end
