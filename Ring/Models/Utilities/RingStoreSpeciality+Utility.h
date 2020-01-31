//
//  RingStoreSpeciality+Utility.h
//  Ring
//
//  Created by Medpats on 12/4/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingStoreSpeciality.h"

@interface RingStoreSpeciality (Utility)
+ (NSArray *)all;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
@end
