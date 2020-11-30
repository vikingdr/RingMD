//
//  Ring-Essentials.h
//  Ring
//
//  Created by RingMD on 10/10/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

#ifndef Ring_Ring_Essentials_h
#define Ring_Ring_Essentials_h

#import "NSDate+Utility.h"
#import "NSString+Utility.h"
#import "UIButton+Utility.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"
#import "UIImage+Utility.h"
#import "UIImageView+Utility.h"
#import "UILabel+Utility.h"
#import "UITextField+Utility.h"
#import "UIView+Utility.h"
#import "UIViewController+Utility.h"

#import "RingData.h"
#import "RingConstant.h"
#import "RingConfigConstant.h"
#import "RingNetworkHelper.h"
#import "RingUtility.h"
#import "RingAppDelegate.h"

#define ASSERT_MAIN_LOOP assert([NSRunLoop mainRunLoop] == [NSRunLoop currentRunLoop])

#define currentUser [RingUtility appDelegate].user
#define ringDelegate [RingUtility appDelegate]

#endif
