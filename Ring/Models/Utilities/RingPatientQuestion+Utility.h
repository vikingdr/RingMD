//
//  RingPatientQuestion+Utility.h
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingPatientQuestion.h"

#define SYMPTOMS_QUESTION 200
#define TREATMENT_QUESTION 201

@interface RingPatientQuestion (Utility)
+ (NSArray *)getByType:(NSString *)type;
+ (void)loadAllSuccess:(void(^)(void))successBlock;
@end
