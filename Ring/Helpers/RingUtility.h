//
//  RingUtility.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

@protocol AFMultipartFormData;

@class AFHTTPRequestOperation, IIViewDeckController, RingAppDelegate;

@interface RingUtility : NSObject

+ (void)parseJsonAttributeWithObject:(NSObject *)object andJsonData:(NSDictionary *)jsonData andPropertyName:(NSString *)propertyName andJsonKey:(NSString *)jsonKey;
+ (NSLocale *)ringLocale;
+ (NSInteger)statusHeight;
+ (NSInteger)navigationHeight;
+ (void)parseJsonAttributeWithObject:(NSObject *)object andJsonData:(NSDictionary *)jsonData andParams:(NSDictionary *)params;


+ (void)checkRequiredVersion;
+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method params:(NSDictionary *)params fullPath:(NSString *)path;
+ (AFHTTPRequestOperation *)operationMultiPartsWithParams:(NSDictionary *)params path:(NSString *)path constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;
+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method params:(NSDictionary *)params path:(NSString *)path;
+ (void)addToOperationToQueue:(AFHTTPRequestOperation *)operation;

+ (RingAppDelegate *)appDelegate;
+ (NSURL *)applicationDocumentsDirectory;
+ (UIViewController *)getViewControllerWithName:(NSString *)name;
+ (NSString *)fullUrlString:(NSString *)url;
+ (BOOL)isIPad;
+ (BOOL)isLandscape;
+ (UIInterfaceOrientation)currentOrientation;
+ (CGFloat)currentWidth;
+ (CGFloat)currentHeight;

+ (void)removeUnreadConversationId:(NSNumber *)conversationId;
+ (void)removeUnreadRequestId:(NSNumber *)requestId;

+ (NSInteger)timeBeforeDisplayCallButton;
+ (NSInteger)timeAfterDisplayCallButton;

+ (AFHTTPRequestOperation *)operationWithMethod:(NSString *)method timeOut:(NSInteger )timeOut params:(NSDictionary *)params fullPath:(NSString *)path;
@end
