//
//  RingPatientAnswer+Utility.h
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPatientAnswer.h"

@interface RingPatientAnswer (Utility)
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
+ (RingPatientAnswer *)findByPatientQuestionId:(NSNumber *)questionId forUser:(RingUser *)user;
+ (RingPatientAnswer *)createEmpty;
@end
