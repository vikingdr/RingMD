//  //
//  RingUtility.m
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "RingUtility.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingOpenTokViewController.h"
#import "RingCallsViewController.h"
#import "Reachability.h"
#import "RingPusher.h"
#import "NSMutableArray+Number.h"

NSInteger timeBeforeDisplayCallButton;
NSInteger timeAfterDisplayCallButton;

@implementation RingUtility

+ (NSString *)getStringTypeOfObject:(NSObject *)object propertyeName:(NSString *)propertyName
{
  objc_property_t attributes = class_getProperty([object class], [propertyName UTF8String]);
  const char *type = property_getAttributes(attributes);
  NSString * typeString = [NSString stringWithUTF8String:type];
  NSArray * attributeStrings = [typeString componentsSeparatedByString:@","];
  NSString * typeAttribute = [attributeStrings objectAtIndex:0];
  NSString * propertyType = [typeAttribute substringWithRange:NSMakeRange(3, typeAttribute.length - 4)];
  return propertyType;
}

+ (NSLocale *)ringLocale
{
  return [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}

+ (void)parseJsonAttributeWithObject:(NSObject *)object andJsonData:(NSDictionary *)jsonData andPropertyName:(NSString *)propertyName andJsonKey:(NSString *)jsonKey
{
  if ([jsonData isEqual:[NSNull null]]) {
    return;
  }
  if ([jsonData objectForKey:jsonKey] != nil && [jsonData objectForKey:jsonKey] != [NSNull null]) {
    NSString *propertyType = [self getStringTypeOfObject:object propertyeName:propertyName];
    
    if ([propertyType isEqualToString:NSStringFromClass([NSDate class])]) {
      [object setValue:[NSDate parse:[jsonData objectForKey:jsonKey]] forKey:propertyName];
    }
    else if ([propertyType isEqualToString:NSStringFromClass([NSNumber class])])
    {
      [object setValue:@([[jsonData objectForKey:jsonKey] integerValue]) forKey:propertyName];
    } else {
      [object setValue:[jsonData objectForKey:jsonKey] forKey:propertyName];
    }
  }
}

+ (void)parseJsonAttributeWithObject:(NSObject *)object andJsonData:(NSDictionary *)jsonData andParams:(NSDictionary *)params
{
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:object andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

+ (AFHTTPRequestOperationManager *)buildOperation
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [manager.requestSerializer setValue:  @"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
  return manager;
}

+ (void)checkRequiredVersion
{
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} fullPath:@"/api/api_informations"];
  [operation perform:^(NSDictionary *json) {
    if (apiVersion < [[json objectForKey:@"ios_required_version"] integerValue]) {
      [[self appDelegate] showRequiredVersion];
      return;
    }
    timeAfterDisplayCallButton = [[json objectForKey:@"request_display_after"] integerValue];
    timeBeforeDisplayCallButton = [[json objectForKey:@"request_display_before"] integerValue];
    assert(timeAfterDisplayCallButton != 0);
    assert(timeBeforeDisplayCallButton != 0);
    
    pusherApiKey = [json objectForKey:@"pusher_key"];
    openTokAPIKEY = [json objectForKey:@"opentok_key"];
    assert(pusherApiKey != nil);
    assert(openTokAPIKEY != nil);
    
    [currentUser subscribe];
  } modally:(openTokAPIKEY == nil && currentUser != nil)];
}

+ (AFHTTPRequestOperation *)operationMultiPartsWithParams:(NSDictionary *)params path:(NSString *)path constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
  NSMutableDictionary *defaultParams = [params mutableCopy];
  if (currentUser) {
    [defaultParams addEntriesFromDictionary:@{@"user_token": currentUser.authToken}];
  }
  NSMutableURLRequest *request = [[self buildOperation].requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[serverAddress stringByAppendingString:[apiVersionPath stringByAppendingString:path]] parameters:defaultParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    block(formData);
  } error:nil];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  return operation;
}

+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method params:(NSDictionary *)params fullPath:(NSString *)path {
  NSMutableDictionary *defaultParams = [NSMutableDictionary dictionaryWithDictionary:@{@"format": @"json"}];
  if (currentUser) {
    [defaultParams addEntriesFromDictionary:@{@"user_token" : currentUser.authToken}];
  }
  [defaultParams addEntriesFromDictionary:params];
  NSError *err = NULL;
  NSMutableURLRequest *request = [[self buildOperation].requestSerializer requestWithMethod:method URLString:[serverAddress stringByAppendingString:path] parameters:defaultParams error:&err];
  assert(err == nil);
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  return operation;
}

+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method timeOut:(NSInteger )timeOut params:(NSDictionary *)params fullPath:(NSString *)path {
  NSMutableDictionary *defaultParams = [NSMutableDictionary dictionaryWithDictionary:@{@"format": @"json"}];
  if (currentUser) {
    [defaultParams addEntriesFromDictionary:@{@"user_token" : currentUser.authToken}];
  }
  [defaultParams addEntriesFromDictionary:params];
  
  NSMutableURLRequest *request = [[self buildOperation].requestSerializer requestWithMethod:method URLString:[serverAddress stringByAppendingString:path] parameters:defaultParams error:nil];
  [request setTimeoutInterval:30];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  return operation;
}

+ (void)addToOperationToQueue:(AFHTTPRequestOperation *)operation
{
  [[[AFHTTPRequestOperationManager manager] operationQueue] addOperation:operation];
  if (![RingNetworkHelper isOnline]) {
    //    [operation pause];
  }
}

+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method params:(NSDictionary *)params path:(NSString *)path {
  return [self operationWithMethod:method params:params fullPath:[apiVersionPath stringByAppendingString:path]];
}

//UTILS

+ (RingAppDelegate *)appDelegate
{
  return (RingAppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (UIViewController *)getViewControllerWithName:(NSString *)name
{
  assert([RingUtility appDelegate].storyboard != nil);
  if ([name isEqualToString:@"openTokVideoCall"]) {
    if ([self isIPad]) {
      return [[RingOpenTokViewController alloc] initWithNibName:@"OpenTokVideoCall_ipad" bundle:nil];
    }
    return [[RingOpenTokViewController alloc] initWithNibName:@"OpenTokVideoCall" bundle:nil];
  }
  return [[RingUtility appDelegate].storyboard instantiateViewControllerWithIdentifier:name];
}

+ (NSString *)fullUrlString:(id)url
{
  if (url == [NSNull null]) {
    return nil;
  }
  if ([url isKindOfClass:[NSDictionary class]]) {
    url = [[url objectForKey:@"thumb_64"] objectForKey:@"url"];
    if ([url isEqual:[NSNull null]]) {
      return @"";
    }
    return url;
  }
  return url;
}

+ (BOOL)isIPad
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
  if ([[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)])
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
#endif
  return NO;
}

+ (UIInterfaceOrientation)currentOrientation
{
  return [UIApplication sharedApplication].statusBarOrientation;
}

+ (NSInteger)statusHeight
{
  return 20;
}

+ (NSInteger)navigationHeight
{
  return 44;
}

+ (BOOL)isLandscape
{
  return [self currentOrientation] == UIInterfaceOrientationLandscapeLeft ||
  [self currentOrientation] == UIInterfaceOrientationLandscapeRight;
}

+ (CGFloat)currentWidth
{
  return [self appDelegate].window.frame.size.width;
}

+ (CGFloat)currentHeight
{
  return [self appDelegate].window.frame.size.height;
}

+ (void)removeUnreadConversationId:(NSNumber *)conversationId
{
  [ringDelegate.unreadConversationIds removeNumber:conversationId];
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
}

+ (void)removeUnreadRequestId:(NSNumber *)requestId
{
  [ringDelegate.unreadRequestIds removeNumber:requestId];
  [[NSNotificationCenter defaultCenter] postNotificationName:ME_userNotification object:nil];
}

+ (NSInteger)timeBeforeDisplayCallButton
{
  return timeBeforeDisplayCallButton;
}

+ (NSInteger)timeAfterDisplayCallButton
{
  return timeAfterDisplayCallButton;
}
@end
