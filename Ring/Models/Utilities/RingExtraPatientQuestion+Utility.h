//
//  RingExtraPatientQuestion+Utility.h
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingExtraPatientQuestion.h"

@interface RingExtraPatientQuestion (Utility)
+ (RingExtraPatientQuestion *)findById:(NSNumber *)extraPatientQuestionId;
+ (RingExtraPatientQuestion *)insertWithJSON:(NSDictionary *)jsonData;
+ (RingExtraPatientQuestion *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
- (void)updateAttributeWithJson:(NSDictionary *)jsonData;
@end
