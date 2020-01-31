//
//  RingMessage+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 9/18/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingMessage.h"

@interface RingMessage (Utility)
+ (RingMessage *)createEmpty;
+ (RingMessage *)insertWithJSON:(NSDictionary *)jsonData;
+ (RingMessage *)findById:(NSNumber *)messageId;
+ (RingMessage *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key;
+ (RingMessage *)insertOrUpdateWithJSON:(NSDictionary *)jsonData;
+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray;
- (void)updateAttributeWithJson:(NSDictionary *)jsonData;
- (BOOL)hasAttach;
- (NSData *)attachData;

- (RingUser *)user;

+ (void)createMessageWithContent:(NSString *)message toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock;
+ (void)createMessageWithImage:(UIImage *)image toUser:(RingUser *)user withSuccess:(void(^)(void))successBlock;
@end
