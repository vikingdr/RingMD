//
//  RingSpeciality+Utility.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "RingSpeciality.h"

@interface RingSpeciality (Utility)
+ (NSArray *)all;
+ (NSArray *)allNonEmpty;
+ (RingSpeciality *)findById:(NSNumber *)specialityId;
+ (RingSpeciality *)insertWithJSON:(NSDictionary *)jsonData;
+ (RingSpeciality *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
+ (NSArray *)allParents;
- (void)updateAttributeWithJson:(NSDictionary *)jsonData;

//Submit server
+ (void)pullSpecialitiesWithSuccess:(void(^)(NSArray *))successBlock;
- (void)loadSpecialistsWithSuccessBlock:(void(^)(NSArray *))successBlock page:(NSInteger)page;
@end
