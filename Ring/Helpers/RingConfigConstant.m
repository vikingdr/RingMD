//
//  RingConfigConstant.m
//  Ring
//
//  Created by Medpats on 7/30/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingConfigConstant.h"

RingConfigConstant *__ringConfigConstantSingleton;

@implementation RingConfigConstant
+ (RingConfigConstant *)sharedInstance
{
  assert(__ringConfigConstantSingleton != nil);
  return __ringConfigConstantSingleton;
}

+ (void)initIPhoneConfig
{
  assert(__ringConfigConstantSingleton == nil);
  __ringConfigConstantSingleton = [RingConfigConstant new];
  
  __ringConfigConstantSingleton.superFontSize = 30;
  __ringConfigConstantSingleton.bigTitleFontSize = 20;
  __ringConfigConstantSingleton.titleFontSize = 18;
  __ringConfigConstantSingleton.textFontSize = 14;
  __ringConfigConstantSingleton.smallFontSize = 10;
  __ringConfigConstantSingleton.tinyFontSize = 8;
  __ringConfigConstantSingleton.menuFontSize = 14;
}

+ (void)initIPadConfig
{
  assert(__ringConfigConstantSingleton == nil);
  __ringConfigConstantSingleton = [RingConfigConstant new];
  
  __ringConfigConstantSingleton.superFontSize = 34;
  __ringConfigConstantSingleton.bigTitleFontSize = 22;
  __ringConfigConstantSingleton.titleFontSize = 20;
  __ringConfigConstantSingleton.textFontSize = 16;
  __ringConfigConstantSingleton.smallFontSize = 13;
  __ringConfigConstantSingleton.tinyFontSize = 10;
  __ringConfigConstantSingleton.menuFontSize = 23;
}
@end
