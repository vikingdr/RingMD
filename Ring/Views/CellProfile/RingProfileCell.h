//
//  RingProfileCell.h
//  Ring
//
//  Created by Tan Nguyen on 11/15/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

@interface RingProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profileCellText;
@property (weak, nonatomic) IBOutlet UIImageView *profileCellIcon;

- (void)decorateUIs;
@end
