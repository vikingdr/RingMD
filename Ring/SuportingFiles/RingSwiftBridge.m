//
//  RingSwiftBridge.m
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 23/09/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingSwiftBridge.h"

#import "RingAppDelegate.h"
#import "RingConstant.h"
#import "RingNetworkHelper.h"
#import "RingAuthUser.h"

@implementation RingSwiftBridge

+ (BOOL)debug {
#ifdef DEBUG
  return YES;
#else
  return NO;
#endif
}

+ (NSString *)ringHomepageURLString {
  return serverAddress;
}

+ (NSString *)ringAPIBaseURLString {
  return [NSString stringWithFormat:@"%@%@/", [self ringHomepageURLString], apiVersionPath];
}

+ (NSString *)userToken {
  return ((RingAppDelegate*)[[UIApplication sharedApplication] delegate]).user.authToken;
}

+ (void)logout {
  [RingNetworkHelper logout];
}

+ (BOOL)isUserOnline:(NSInteger)userId
{
  for(NSNumber *n in [((RingAppDelegate*)[[UIApplication sharedApplication] delegate]) onlineUserIds]) {
    if([n integerValue] == userId) {
      return YES;
    }
  }
  
  return NO;
}
@end
