//
//  RingAttachFile+Utility.h
//  Ring
//
//  Created by Medpats on 1/24/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingAttachFile.h"

@interface RingAttachFile (Utility)
+ (RingAttachFile *)createEmpty;
+ (RingAttachFile *)insertWithJSON:(NSDictionary *)jsonData;

- (NSURL *)tempFileURL;
- (NSData *)attachData;
- (void)setAttachData:(NSData *)data;
- (NSDictionary *)toParameters;
- (void)fetchDataWithSuccessBlock:(void(^)())success;
@end
