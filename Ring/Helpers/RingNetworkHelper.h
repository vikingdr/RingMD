//
//  RingNetworkHelper.h
//  Ring
//
//  Created by Medpats on 12/13/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

@interface RingNetworkHelper : NSObject
+ (void)deleteAllCookies;
+ (void)initMonitorNetwork;
+ (void)openBrowserWithUrlString:(NSString *)url;
+ (BOOL)hasError:(NSDictionary *)json;
+ (NSString *)errorMessage:(NSDictionary *)json;
+ (BOOL)isOnline;
+ (void)logout;
@end
