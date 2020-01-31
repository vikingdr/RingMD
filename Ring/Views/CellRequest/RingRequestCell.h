//
//  RingRequestCell.h
//  Ring
//
//  Created by Medpats on 5/9/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingCallRequest;

@interface RingRequestCell : UITableViewCell
@property (weak, nonatomic) RingCallRequest *request;

+ (NSString *)nibName;
@end
