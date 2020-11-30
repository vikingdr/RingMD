//
//  RingCountry+Utility.h
//  Ring
//
//  Created by Medpats on 3/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingCountry.h"

@interface RingCountry (Utility)
+ (RingCountry *)findById:(NSNumber *)countryId;
+ (void)pullCountriesWithSuccess:(void(^)(NSArray *))successBlock;
+ (NSArray *)all;
@end
