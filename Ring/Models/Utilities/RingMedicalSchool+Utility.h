//
//  RingMedicalSchool+Utility.h
//  Ring
//
//  Created by Medpats on 3/21/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingMedicalSchool.h"

@interface RingMedicalSchool (Utility)
+ (void)searchMedicalSchoolsWithText:(NSString *)text andSuccess:(void(^)(NSArray *))successBlock;
@end
