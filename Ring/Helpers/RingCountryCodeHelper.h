//
//  RingCountryCodeHelper.h
//  Ring
//
//  Created by Medpats on 5/19/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@interface RingCountryCodeHelper : NSObject
+ (RingCountryCodeHelper *)sharedInstance;

- (NSArray *)allCodes;
- (NSArray *)allCountries;
@end
