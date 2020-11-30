//
//  RingMedialHistory.h
//  Ring
//
//  Created by Medpats on 8/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingUser;
@protocol RingQuetionCellDelegate;

@interface RingMedialHistory : UITableView
@property (nonatomic, strong) RingUser *user;

@property (weak, nonatomic) IBOutlet id<RingQuetionCellDelegate> questionCellDelegate;
@end
