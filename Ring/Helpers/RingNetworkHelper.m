//
//  RingNetworkHelper.m
//  Ring
//
//  Created by Medpats on 12/13/2556 BE.
//  Copyright (c) 2556 Matthew James All rights reserved.
//

#import "RingNetworkHelper.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "Reachability.h"
#import "RingPusher.h"

@implementation RingNetworkHelper
+ (void)openBrowserWithUrlString:(NSString *)url
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)initMonitorNetwork
{
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  reachability.reachableBlock = ^(Reachability *reachability) {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Established network connection");
        [currentUser subscribe];
        [[NSNotificationCenter defaultCenter] postNotificationName:CE_onlinechanged object:nil];
      });
    };
  reachability.unreachableBlock = ^(Reachability *reachability) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"Lost network connection");
      [currentUser unSubscribe];
    });
  };
  [reachability startNotifier];
}

+ (BOOL)isOnline
{
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  BOOL offline = [reachability currentReachabilityStatus] == NotReachable;
  return !offline;
}

+ (void)logout
{
  [AFHTTPRequestOperation cancelAll];
  currentUser = nil;
  [RingNetworkHelper deleteAllCookies];
  [[RingData sharedInstance] resetDatabase];
  [[RingNavigationController sharedNavigationController] popToRootViewControllerAnimated:YES];
}

+ (void)deleteAllCookies
{
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:serverAddress]];
  for (NSHTTPCookie *cookie in cookies)
  {
    NSLog(@"Deleting cookie %@", cookie.name);
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
  }
}

+ (BOOL)hasError:(NSDictionary *)json
{
  if ([json objectForKey:@"error"]) {
    NSLog(@"Ring network helper error: %@", [json objectForKey:@"errors"]);
    [UIViewController showMessage:[json valueForKey:@"error"] withTitle:@"Update Error"];
    return YES;
  }
  if ([json objectForKey:@"errors"]) {
    NSDictionary *error = [json objectForKey:@"errors"];
    NSObject *value = [[error allValues] firstObject];
    NSString *key = [[error allKeys] firstObject];
    if ([value isKindOfClass:[NSArray class]]) {
      value = [(NSArray *)value firstObject];
    }
    NSLog(@"Ring network helper errors: %@", [json objectForKey:@"errors"]);
    [UIViewController showMessage:[NSString stringWithFormat:@"%@ %@", key, value] withTitle:@"Update Error"];
    return YES;
  }
  return NO;
}

+ (NSString *)errorMessage:(NSDictionary *)json
{
  if ([json objectForKey:@"message"]) {
    return [json objectForKey:@"message"];
  }
  if ([json objectForKey:@"errors"]) {
    return [[json objectForKey:@"errors"] firstObject];
  }
  return @"Unknown error. Please try again or contact support@ring.md for assistance.";
}
@end
