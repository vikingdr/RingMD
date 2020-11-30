//
//  RingConfigConstant.h
//  Ring
//
//  Created by Medpats on 7/30/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define IS_IPHONE_4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE_5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_DOCTOR [[currentUser isDoctor] boolValue]
#define IS_IPAD [RingUtility isIPad]
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define PICKER_HEIGHT 216
#define PICKER_FRAME IS_OS_7_OR_LATER ? CGRectMake(0, 0, [RingUtility currentWidth], PICKER_HEIGHT) : CGRectMake(0, self.frame.size.height - PICKER_HEIGHT, [RingUtility currentWidth], PICKER_HEIGHT)

#define RINGMD_BUTTON_HEIGHT 44

#define TOPVIEW_OFFSET (IS_OS_7_OR_LATER ? 66 : 0)

@interface RingConfigConstant : NSObject
@property (nonatomic) CGFloat bigTitleFontSize;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat textFontSize;
@property (nonatomic) CGFloat smallFontSize;
@property (nonatomic) CGFloat tinyFontSize;
@property (nonatomic) CGFloat superFontSize;
@property (nonatomic) CGFloat menuFontSize;

+ (RingConfigConstant *)sharedInstance;
+ (void)initIPhoneConfig;
+ (void)initIPadConfig;
@end
