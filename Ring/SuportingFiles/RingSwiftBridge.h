//
//  RingSwiftBridge.h
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 23/09/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

@interface RingSwiftBridge : NSObject

+ (BOOL)debug;

// E.g. http://example.ring.com
+ (NSString *)ringHomepageURLString;

// E.g. http://example.ring.com/teh-api/version-9000/
+ (NSString *)ringAPIBaseURLString;

+ (NSString *)userToken;

+ (void)logout;

+ (BOOL)isUserOnline:(NSInteger)userId;
@end
