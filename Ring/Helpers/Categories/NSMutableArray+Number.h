//
//  NSMutableArray+Number.h
//  Ring
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Number)
- (void)removeNumber:(NSNumber *)removeNumber;
- (void)removeString:(NSString *)removeNumber;
- (void)addNumber:(NSNumber *)number;
@end
