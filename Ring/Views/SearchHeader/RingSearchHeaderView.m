//
//  RingSearchHeaderView.m
//  Ring
//
//  Created by Medpats on 5/8/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingSearchHeaderView.h"

#import "Ring-Essentials.h"

@interface RingSearchHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation RingSearchHeaderView

+ (RingSearchHeaderView *)initRingSeachHeader
{
  RingSearchHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:@"SearchHeader" owner:nil options:nil] lastObject];
  if ([customView isKindOfClass:[RingSearchHeaderView class]]) {
    [customView decorateUIs];
    return customView;
  }
  return nil;
}

- (void)decorateUIs
{
  self.labelText.text = @"Browse by Specialty";
  self.labelText.textColor = [UIColor ringOrangeColor];
  self.labelText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.backgroundColor = [UIColor colorWithRed:0.949 green:0.969 blue:0.973 alpha:1];
}
@end
